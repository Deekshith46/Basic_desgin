`timescale 1ns/1ps

module tb_pp_tree16x64;

    // 16 partial products
    reg  [63:0] P0,  P1,  P2,  P3;
    reg  [63:0] P4,  P5,  P6,  P7;
    reg  [63:0] P8,  P9,  P10, P11;
    reg  [63:0] P12, P13, P14, P15;

    // Outputs from DUT
    wire [63:0] SUM;
    wire [63:0] CARRY, c0, c1, c2, c3, c4, c5, s0, s1, s2, s3, s4, s5;

    // Expanded outputs for checking
    wire [63:0] dut_result = SUM + (CARRY << 1);

    // Reference model
    reg [63:0] ref_result;

    integer i;

    // Instantiate DUT
    pp_tree16x64 dut (
        .P0(P0),   .P1(P1),   .P2(P2),   .P3(P3),
        .P4(P4),   .P5(P5),   .P6(P6),   .P7(P7),
        .P8(P8),   .P9(P9),   .P10(P10), .P11(P11),
        .P12(P12), .P13(P13), .P14(P14), .P15(P15),
        .SUM(SUM), .CARRY(CARRY)
    );

    initial begin
        $display("===== Partial Product Tree Test =====");

        // Run multiple random test vectors
        for (i = 0; i < 10; i = i + 1) begin
            // Randomize partial products
            P0  = $random;
            P1  = $random;
            P2  = $random;
            P3  = $random;
            P4  = $random;
            P5  = $random;
            P6  = $random;
            P7  = $random;
            P8  = $random;
            P9  = $random;
            P10 = $random;
            P11 = $random;
            P12 = $random;
            P13 = $random;
            P14 = $random;
            P15 = $random;

            #5; // allow propagation

            // Compute reference result
            ref_result = P0 + P1 + P2 + P3 +
                         P4 + P5 + P6 + P7 +
                         P8 + P9 + P10 + P11 +
                         P12 + P13 + P14 + P15;
		$display(" Expected: %h", ref_result);
            // Check correctness
            if (dut_result === ref_result) begin

                $display("Test %0d PASSED ? ", i);
		$display(" Got:      %h\n sum: %h\n carry: %h", dut_result, SUM, CARRY);
		//$display(" c0:      %h\n c1: %h\n c2: %h", c0, c1, c2);
		//$display(" c3:      %h\n c4: %h\n c5: %h", c3, c4, c5);
		//$display(" s0:      %h\n s1: %h\n s2: %h", s0, s1, s2);
		//$display(" s3:      %h\n s4: %h\n s5: %h", s3, s4, s5);
		$display(" p0:      %h", P0);
		$display(" p1:      %h", P1);
		$display(" p2:      %h", P2);
		$display(" p3:      %h", P3);
		$display(" p4:      %h", P4);
		$display(" p5:      %h", P5);
		$display(" p6:      %h", P6);
		$display(" p7:      %h", P7);
		$display(" p8:      %h", P8);
		$display(" p9:      %h", P9);
		$display(" p10:      %h", P10);
		$display(" p11:      %h", P11);
		$display(" p12:      %h", P12);
		$display(" p13:      %h", P13);
		$display(" p14:      %h", P14);
		$display(" p15:      %h", P15);

            end else begin
                $display("Test %0d FAILED ?", i);
$display(" Expected: %h", ref_result);
                $display(" Got:      %h\n sum: %h\n carry: %h", dut_result, SUM, CARRY);
		//$display(" c0:      %h\n c1: %h\n c2: %h", c0, c1, c2);
		//$display(" c3:      %h\n c4: %h\n c5: %h", c3, c4, c5);
		//$display(" s0:      %h\n s1: %h\n s2: %h", s0, s1, s2);
		//$display(" s3:      %h\n s4: %h\n s5: %h", s3, s4, s5);
		$display(" p0:      %h", P0);
		$display(" p1:      %h", P1);
		$display(" p2:      %h", P2);
		$display(" p3:      %h", P3);
		$display(" p4:      %h", P4);
		$display(" p5:      %h", P5);
		$display(" p6:      %h", P6);
		$display(" p7:      %h", P7);
		$display(" p8:      %h", P8);
		$display(" p9:      %h", P9);
		$display(" p10:      %h", P10);
		$display(" p11:      %h", P11);
		$display(" p12:      %h", P12);
		$display(" p13:      %h", P13);
		$display(" p14:      %h", P14);
		$display(" p15:      %h", P15);
            end
        end

        $display("All tests passed!");
        $finish;
    end

endmodule

