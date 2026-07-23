// op_test_div.sv (testbench corrigido)
module tb();
    // sinais correspondentes aos ports do DUT (opdiv)
    logic                clock;
    logic                nreset;
    logic signed [31:0]  a;
    logic signed [31:0]  b;
    logic signed [31:0]  c;
    logic signed [31:0]  r;
    logic                in_valid_i;
    logic                in_ready_o;
    logic                out_valid_o;
    logic                signal_division;
    logic                out_ready_i;

    // instancia do DUT (assumindo portas com exatamente estes nomes)
    opdiv dut (
        .clock(clock),
        .nreset(nreset),
        .a(a),
        .b(b),
        .c(c),
        .r(r),
        .in_valid_i(in_valid_i),
        .in_ready_o(in_ready_o),
        .out_valid_o(out_valid_o),
        .signal_division(signal_division),
        .out_ready_i(out_ready_i)
    );

    // clock generation: 10 time units period
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // stimulus
    initial begin
        // inicialização
        nreset = 0;
        in_valid_i = 0;
        out_ready_i = 1;
        signal_division = 1'b1;
        a = 32'sd0;
        b = 32'sd1;

        #20;
        nreset = 1; // libera reset

        // 1) caso simples (evitar literal > 32-bit signed)
        @(posedge clock);
        a = 32'sd100;    // 100
        b = 32'sd3;      // 3
        in_valid_i = 1;
        @(posedge clock);
        in_valid_i = 0;

        // aguarda alguns ciclos (observe outputs)
        repeat (50) @(posedge clock);

        // 2) caso com número negativo
        @(posedge clock);
        a = 32'sd200;
        b = 32'sd7;
        in_valid_i = 1;
        @(posedge clock);
        in_valid_i = 0;

        repeat (50) @(posedge clock);

        $display("Fim da simulação em tempo %0t", $time);
        $finish;
    end

    // monitora quando o DUT sinaliza saída válida
    always_ff @(posedge clock) begin
        if (out_valid_o) begin
            $display("TIME=%0t a=%0d b=%0d -> c=%0d r=%0d", $time, a, b, c, r);
        end
    end

endmodule
