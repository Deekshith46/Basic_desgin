
`timescale 1ns/1ps

module tb_booth_radix4_multiplier;

    // DUT inputs
    reg  [31:0] A;
    reg  [31:0] B;
    reg         alu_signed;

    // DUT outputs
    wire [63:0] PP0, PP1, PP2, PP3;
    wire [63:0] PP4, PP5, PP6, PP7;
    wire [63:0] PP8, PP9, PP10, PP11;
    wire [63:0] PP12, PP13, PP14, PP15, PP16;

    // Instantiate DUT
    booth_radix4_multiplier dut (
        .A(A),
        .B(B),
        .alu_signed(alu_signed),
        .PP0(PP0), .PP1(PP1), .PP2(PP2), .PP3(PP3),
        .PP4(PP4), .PP5(PP5), .PP6(PP6), .PP7(PP7),
        .PP8(PP8), .PP9(PP9), .PP10(PP10), .PP11(PP11),
        .PP12(PP12), .PP13(PP13), .PP14(PP14), .PP15(PP15), .PP16(PP16)
    );

    // Task to print partial products in signed form
    task print_pp;
        begin
            $display("PP0  = %0h", $signed(PP0));
            $display("PP1  = %0h", $signed(PP1));
            $display("PP2  = %0h", $signed(PP2));
            $display("PP3  = %0h", $signed(PP3));
            $display("PP4  = %0h", $signed(PP4));
            $display("PP5  = %0h", $signed(PP5));
            $display("PP6  = %0h", $signed(PP6));
            $display("PP7  = %0h", $signed(PP7));
            $display("PP8  = %0h", $signed(PP8));
            $display("PP9  = %0h", $signed(PP9));
            $display("PP10 = %0h", $signed(PP10));
            $display("PP11 = %0h", $signed(PP11));
            $display("PP12 = %0h", $signed(PP12));
            $display("PP13 = %0h", $signed(PP13));
            $display("PP14 = %0h", $signed(PP14));
            $display("PP15 = %0h", $signed(PP15));
            $display("PP16 = %0h", $signed(PP16));
        end
    endtask

    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
    end
    initial begin
        // Test 1: Unsigned 5 × 3
        alu_signed = 0;
        A = 32'd5;
        B = 32'd3;
        #10;
        $display("=== Test 1: Unsigned (5 × 3) ===");
        print_pp();

        // Test 2: Signed -5 × 3
        alu_signed = 1;
        A = -32'd5;
        B = 32'd3;
        #10;
        $display("=== Test 2: Signed (-5 × 3) ===");
        print_pp();

        $finish;
    end

endmodule

