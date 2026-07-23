`timescale 1ns/1ps

module tb_opdiv;

    // DUT signals
    logic clock;
    logic nreset;

    logic signed [31:0] a;
    logic signed [31:0] b;

    logic signed [31:0] c;   // quociente
    logic signed [31:0] r;   // resto

    logic in_valid_i;
    logic in_ready_o;

    logic out_valid_o;
    logic out_ready_i;

    logic signal_division; // 1=signed, 0=unsigned

    // Clock
    always #5 clock = ~clock;

    // DUT
    opdiv dut(
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

    // Tasks ===============================================

    task automatic apply_div
    (
        input signed [31:0] A,
        input signed [31:0] B,
        input bit signed_mode
    );
    begin
        @(posedge clock);

        a = A;
        b = B;
        signal_division = signed_mode;

        in_valid_i = 1'b1;

        // espera pronto
        while (!in_ready_o) @(posedge clock);

        // envia
        @(posedge clock);
        in_valid_i = 1'b0;

        // espera resultado
        while (!out_valid_o) @(posedge clock);

        // sinaliza que pode entregar
        out_ready_i = 1;

        @(posedge clock);
        out_ready_i = 0;

        $display("[%0t] A=%0d  B=%0d  signed=%0d  =>  C=%0d  R=%0d",
                 $time, A, B, signed_mode, c, r);
    end
    endtask

    // ======================================================

    initial begin
        // inicialização
        clock = 0;
        nreset = 0;

        in_valid_i = 0;
        out_ready_i = 0;

        a = 0;
        b = 0;
        signal_division = 0;

        repeat(4) @(posedge clock);
        nreset = 1;

        // ---------------------------------------
        // TESTES BÁSICOS
        // ---------------------------------------
        $display("==== TESTE: divisão básica sem sinal ====");
        apply_div(100, 5, 0);

        $display("==== TESTE: divisão básica com sinal ====");
        apply_div(-100, 5, 1);
        apply_div(100, -5, 1);
        apply_div(-100, -5, 1);

        // ---------------------------------------
        // EXCEÇÃO: divisão por zero
        // ---------------------------------------
        $display("==== TESTE: divisão por zero ====");
        apply_div(123, 0, 1);
        apply_div(123, 0, 0);

        // ---------------------------------------
        // EXCEÇÃO: |a| < |b|
        // ---------------------------------------
        $display("==== TESTE: |a| < |b| ====");
        apply_div(3, 10, 1);
        apply_div(-3, 10, 1);

        // ---------------------------------------
        // EXCEÇÃO: a = 0
        // ---------------------------------------
        $display("==== TESTE: A = 0 ====");
        apply_div(0, 10, 1);
        apply_div(0, -10, 1);

        // ---------------------------------------
        // EXCEÇÃO: MIN INT (-2^31)
        // ---------------------------------------
        $display("==== TESTE: MIN INT ====");
        apply_div(32'h80000000, 2, 1);
        apply_div(32'h80000000, -1, 1);
        apply_div(32'h80000000, -2, 1);

        // ---------------------------------------
        // RANDOM TESTS
        // ---------------------------------------
        $display("==== TESTE RANDOM ====");
        repeat (20) begin
            apply_div( $urandom_range(-1000, 1000),
                       $urandom_range(-1000, 1000),
                       $urandom_range(0,1));
        end

        // ---------------------------------------
        $display("SIMULAÇÃO FINALIZADA");
        #50;
        $finish;
    end

endmodule
