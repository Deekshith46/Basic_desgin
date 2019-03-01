// tb_booth_radix4_multiplier.v
`timescale 1ns/1ps
module tb_booth_radix4_multiplier;

    reg signed [3:0] A, B;   // inputs
    wire signed [7:0] P;     // DUT output
    reg signed [7:0] expected;

    integer i, j;

    // Instantiate DUT
    booth_radix4_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
        $dumpfile("booth_mult.vcd");
        $dumpvars(0, tb_booth_radix4_multiplier);

        $shm_open("wave.shm");
        $shm_probe("ACTMF");

        $display("Testing Booth Radix-4 Multiplier...");

        // Loop through some test cases
        for (i = -8; i <= 7; i = i + 1) begin
            for (j = -8; j <= 7; j = j + 1) begin
                A = i;
                B = j;
                expected = A * B;
                #5; // wait for DUT to compute

                if (P !== expected) begin
                    $display("FAIL: A=%0d, B=%0d | DUT=%0d, Expected=%0d", 
                             A, B, P, expected);
                end else begin
                    $display("PASS: A=%0d, B=%0d | Product=%0d", 
                             A, B, P);
                end
            end
        end

        $finish;
    end
endmodule
