module opdiv(
    input  logic                clock,
    input  logic                nreset,
    input  logic signed [31:0]  a,
    input  logic signed [31:0]  b,
    output logic signed [31:0]  c,
    output logic signed [31:0]  r,
    input  logic                in_valid_i,    //  
    output logic                in_ready_o,    //  
    output logic                out_valid_o,   //  
    
    input  logic                signal_division,
    input  logic                out_ready_i    //
);
    // sinais internos
    logic               ena;
    logic               a_signal, b_signal, signal_division_intern, c_signal;
    logic               next_in_ready_o, next_out_valid_o;
    logic               compair;
    logic [10:0]        qbits;                // counter_bit produz nBits [10:0]
    logic [5:0]         k;                    // índice para Quatient
    logic [5:0]         next_k;
    logic signed [32:0] r_temp;               // corrigido para 33 bits (subtração com minuend/b_reg)
    logic signed [32:0] a_reg, b_reg, minuend; // mantidos 33 bits (signed)
    logic signed [33:0] left_updade, right_updade; // 34 bits resultado das concatenações
    logic signed [31:0] Quatient;             // quociente (32 bits)
    
    // FSM: estados tipados adequadamente
    typedef enum logic [2:0] {
        IDLE,
        INITIALISE_AND_COUNTER_BITS,
        SET_AK_MINUEND,
        LOOP,
        UPDATE_MINUEND_RIGHT,
        UPDATE_MINUEND_LEFT,
        INCREASE_K,
        DONE
    } state_t;

    state_t state, next;

    // contador de bits (instanciação)
    counter_bit inst0Count(
        .ena   (ena),
        .A     (a_reg[31:0]), // passa somente 32 bits como esperado pelo contador
        .nBits (qbits)
    );

    // Reset síncrono/assíncrono (ff)
    always_ff @(posedge clock or negedge nreset) begin
        if (!nreset) begin
            a_reg       <= '0;
            b_reg       <= '0;
            Quatient    <= '0;
            state       <= IDLE;
            ena         <= 1'b0;
            minuend     <= '0;
            a_signal    <= 1'b0;
            b_signal    <= 1'b0;
            in_ready_o  <= 1'b0;
            out_valid_o <= 1'b0;
            k           <= '0;
            signal_division_intern <= 1'b0;
        end else begin
            // comportamento por próximo estado
            case (next)
                INITIALISE_AND_COUNTER_BITS: begin
                    Quatient <= '0;
                    if (signal_division_intern) begin
                        // extende/ajusta magnitude em 33 bits: [32:0]
                        a_reg[30:0] <= a[30:0];
                        a_reg[32:31] <= (a[31] && a[30:0] == 0) ? 2'b01 : 2'b00;
                        // se sinal negativo, magnitude armazenada em complemento de dois / magnitude
                        if (a[31]) a_reg[30:0] <= ~a[30:0] + 1'b1;

                        b_reg[30:0] <= b[30:0];
                        b_reg[32:31] <= (b[31] && b[30:0] == 0) ? 2'b01 : 2'b00;
                        if (b[31]) b_reg[30:0] <= ~b[30:0] + 1'b1;
                    end else begin
                        // guarda valor sem sinal extendido (bit extra em MSB 0)
                        a_reg <= {1'b0, a};
                        b_reg <= {1'b0, b};
                    end
                    ena         <= 1'b1;
                    minuend     <= '0;
                    // qbits é 11 bits, mas k é 6 bits - truncamos (esperado <= 31)
                    k           <= qbits[5:0];
                    a_signal    <= a[31] & signal_division_intern;
                    b_signal    <= b[31] & signal_division_intern;
                end

                SET_AK_MINUEND: begin
                    minuend     <= 33'd1;
                    ena         <= 1'b0;
                    Quatient    <= '0;
                    // mantém regs
                    k           <= qbits[5:0];
                    // a_reg, b_reg mantidos
                end

                LOOP: begin
                    if (compair) begin
                        // seta bit do quociente (não faz sentido atribuir com índice >31; k é 6 bits)
                        // montagem do Quatient fica por atribuição bit a bit:
                        Quatient[k] <= 1'b1;
                        ena         <= 1'b0;
                        // outros sinais mantidos
                    end else begin
                        Quatient[k] <= 1'b0;
                        // mantém outros sinais
                    end
                end

                UPDATE_MINUEND_RIGHT: begin
                    minuend     <= right_updade;
                    // demais regs mantidos
                end

                INCREASE_K: begin
                    k           <= next_k;
                    // demais regs mantidos
                end

                UPDATE_MINUEND_LEFT: begin
                    minuend     <= left_updade;
                    // demais regs mantidos
                end

                DONE: begin
                    // mantém resultados finais
                end

                default: begin
                    a_reg    <= '0;
                    b_reg    <= '0;
                    Quatient <= '0;
                    state    <= IDLE;
                    ena      <= 1'b0;
                    minuend  <= '0;
                    k        <= '0;
                    a_signal <= 1'b0;
                    b_signal <= 1'b0;
                end
            endcase

            // atualiza estado e sinais de handshake
            state       <= next;
            in_ready_o  <= next_in_ready_o;
            out_valid_o <= next_out_valid_o;

            // atualização da signal_division_intern conforme lógica original
            if (k == 0)
                signal_division_intern <= signal_division;
            else
                signal_division_intern <= (in_valid_i && in_ready_o) ? signal_division : signal_division_intern;
        end
    end

    // Lógica combinacional do FSM
    always_comb begin
        // defaults
        next = state;                    // mesmo tipo state_t
        next_in_ready_o = 1'b0;
        next_out_valid_o = 1'b0;

        case (state)
            IDLE: begin
                if (in_valid_i && in_ready_o) begin
                    next = INITIALISE_AND_COUNTER_BITS;
                    next_in_ready_o = 1'b0;
                    next_out_valid_o = 1'b0;
                end else begin
                    next = IDLE;
                    next_in_ready_o = 1'b1; // pronto para receber
                    next_out_valid_o = 1'b0;
                end
            end

            INITIALISE_AND_COUNTER_BITS: begin
                next = SET_AK_MINUEND;
                next_in_ready_o = 1'b0;
                next_out_valid_o = 1'b0;
            end

            SET_AK_MINUEND: begin
                next = LOOP;
                next_in_ready_o = 1'b0;
                next_out_valid_o = 1'b0;
            end

            LOOP: begin
                if (compair) begin
                    if (k == 0) begin
                        next = DONE;
                        next_in_ready_o = 1'b0;
                        next_out_valid_o = 1'b1;
                    end else begin
                        next = UPDATE_MINUEND_RIGHT;
                        next_in_ready_o = 1'b0;
                        next_out_valid_o = 1'b0;
                    end
                end else begin
                    if (k == 0) begin
                        next = DONE;
                        next_in_ready_o = 1'b0;
                        next_out_valid_o = 1'b1;
                    end else begin
                        next = UPDATE_MINUEND_LEFT;
                        next_in_ready_o = 1'b0;
                        next_out_valid_o = 1'b0;
                    end
                end
            end

            UPDATE_MINUEND_RIGHT: begin
                next = INCREASE_K;
                next_in_ready_o = 1'b0;
                next_out_valid_o = 1'b0;
            end

            UPDATE_MINUEND_LEFT: begin
                next = INCREASE_K;
                next_in_ready_o = 1'b0;
                next_out_valid_o = 1'b0;
            end

            INCREASE_K: begin
                next = LOOP;
                next_in_ready_o = 1'b0;
                next_out_valid_o = 1'b0;
            end

            DONE: begin
                if (!out_ready_i) begin
                    next = DONE;
                    next_in_ready_o = 1'b0;
                    next_out_valid_o = 1'b1;
                end else begin
                    next = IDLE;
                    next_in_ready_o = 1'b1;
                    next_out_valid_o = 1'b0;
                end
            end

            default: begin
                next = IDLE;
                next_in_ready_o = 1'b1;
                next_out_valid_o = 1'b0;
            end
        endcase
    end

    // assign corrigido: r_temp tem largura compatível (33 bits)
    assign r_temp = compair ? (minuend - b_reg) : minuend;

    // saída (combinacional)
    always_comb begin
        // default outputs indeterminados quando não válidos
        c = 'x;
        r = 'x;

        // usa sinais de saída atuais (out_valid_o) e handshake
        if (out_valid_o && out_ready_i) begin
            if (signal_division_intern) begin
                // comparações com largura correta
                if (b_reg == 33'd0) begin
                    c = {32{1'b1}}; // divisor 0 -> divisão por zero, max negative? mantive comportamento original
                    r = a_signal ? (~a_reg[30:0] + 1'b1) : a_reg[30:0];
                end
                else if ((a_reg[30:0] != 0) && (a_reg[30:0] < b_reg[30:0])) begin
                    c = {32{1'b0}};
                    r = a_signal ? (~a_reg[30:0] + 1'b1) : a_reg[30:0];
                end
                else if ((a_reg != 33'h080000000) && (a_reg[30:0] == 0)) begin
                    c = 32'd0;
                    r = 32'd0;
                end else begin
                    case ({a_signal, b_signal})
                        2'b00: begin
                            c = {1'b0, Quatient[30:0]};
                            r = r_temp;
                        end

                        2'b11: begin
                            c = (a_reg[31:0] == 32'h80000000) ? Quatient[31:0] : {1'b0, Quatient[30:0]};
                            r = ~r_temp + 1'b1;
                        end

                        2'b10: begin
                            c = (a_reg[31:0] == 32'h80000000) ? (~Quatient[31:0] + 1'b1) : {1'b1, ~Quatient[30:0] + 1'b1};
                            r = ~r_temp + 1'b1;
                        end

                        2'b01: begin
                            c = {1'b1, ~Quatient[30:0] + 1'b1};
                            r = r_temp;
                        end

                        default: begin
                            r = 32'd15;
                        end
                    endcase
                end
            end else begin
                // divisão sem sinal (ou caminho alternativo)
                if (b_reg[31:0] == 32'd0) begin
                    c = {32{1'b1}};
                    r = a_reg[31:0];
                end
                else if (a_reg[31:0] < b_reg[31:0]) begin
                    c = {32{1'b0}};
                    r = a_reg[31:0];
                end else begin
                    c = Quatient;
                    r = r_temp;
                end
            end
        end
    end

    // comparação segura (com largura correta)
    always_comb begin
        compair = ((minuend - b_reg) >= 33'd0);
    end

    // atualizações do minuend (concatena 33 bits + 1 bit -> 34 bits)
    always_comb begin
        // controla next_k: evita wrap negativo
        if (k > 0)
            next_k = k - 1;
        else
            next_k = k;
    end

    always_comb begin
        left_updade  = {minuend, a_reg[next_k]};         // 33 + 1 = 34 bits
        right_updade = {(minuend - b_reg), a_reg[next_k]}; // 33 + 1 = 34 bits
    end

endmodule


module counter_bit(
    input   logic        ena,
    input   logic [31:0] A,
    output  logic [10:0] nBits
);
    always_comb begin
        if (ena) begin
            casex (A[31:0])
                32'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd31;
                32'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd30;
                32'b001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd29;
                32'b0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd28;
                32'b0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd27;
                32'b0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd26;
                32'b0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd25;
                32'b0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd24;
                32'b0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd23;
                32'b0000_0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd22;
                32'b0000_0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd21;
                32'b0000_0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd20;
                32'b0000_0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd19;
                32'b0000_0000_0000_01xx_xxxx_xxxx_xxxx_xxxx: nBits = 11'd18;
                32'b0000_0000_0000_001x_xxxx_xxxx_xxxx_xxxx: nBits = 11'd17;
                32'b0000_0000_0000_0001_xxxx_xxxx_xxxx_xxxx: nBits = 11'd16;
                32'b0000_0000_0000_0000_1xxx_xxxx_xxxx_xxxx: nBits = 11'd15;
                32'b0000_0000_0000_0000_01xx_xxxx_xxxx_xxxx: nBits = 11'd14;
                32'b0000_0000_0000_0000_001x_xxxx_xxxx_xxxx: nBits = 11'd13;
                32'b0000_0000_0000_0000_0001_xxxx_xxxx_xxxx: nBits = 11'd12;
                32'b0000_0000_0000_0000_0000_1xxx_xxxx_xxxx: nBits = 11'd11;
                32'b0000_0000_0000_0000_0000_01xx_xxxx_xxxx: nBits = 11'd10;
                32'b0000_0000_0000_0000_0000_001x_xxxx_xxxx: nBits = 11'd9;
                32'b0000_0000_0000_0000_0000_0001_xxxx_xxxx: nBits = 11'd8;
                32'b0000_0000_0000_0000_0000_0000_1xxx_xxxx: nBits = 11'd7;
                32'b0000_0000_0000_0000_0000_0000_01xx_xxxx: nBits = 11'd6;
                32'b0000_0000_0000_0000_0000_0000_001x_xxxx: nBits = 11'd5;
                32'b0000_0000_0000_0000_0000_0000_0001_xxxx: nBits = 11'd4;
                32'b0000_0000_0000_0000_0000_0000_0000_1xxx: nBits = 11'd3;
                32'b0000_0000_0000_0000_0000_0000_0000_01xx: nBits = 11'd2;
                32'b0000_0000_0000_0000_0000_0000_0000_001x: nBits = 11'd1;
                32'b0000_0000_0000_0000_0000_0000_0000_0001: nBits = 11'd0;
                default: nBits = 11'd0;
            endcase
        end else begin
            nBits = 11'd0;
        end
    end
endmodule
