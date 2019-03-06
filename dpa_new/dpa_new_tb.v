`timescale 1ns/1ps

module tb_all_cases;

  localparam WIDTH  = 32;
  localparam OP_LEN = 5;

  reg  [WIDTH-1:0] a;
  reg  [WIDTH-1:0] b;
  reg  [OP_LEN-1:0] opcode;
  wire [WIDTH-1:0] final_sum;
  wire cout, negative_flag, overflow_flag, zero_flag;

  // DUT
  top #(.WIDTH(WIDTH), .OP_LEN(OP_LEN)) dut (
    .a(a), .b(b), .opcode(opcode),
    .final_sum(final_sum),
    .cout(cout),
    .negative_flag(negative_flag),
    .overflow_flag(overflow_flag),
    .zero_flag(zero_flag)
  );

  // helper vars for expected values
  reg [WIDTH:0] temp_sum;      // WIDTH+1 to capture carry-out
  reg [WIDTH-1:0] expected_sum;
  reg expected_cout;
  reg [WIDTH-1:0] expected_tc;
  reg expected_tc_cout;

  // helper vars for subtraction expected values
  reg [WIDTH:0] temp_sub;
  reg [WIDTH-1:0] expected_sub;
  reg expected_sub_cout;

  initial begin
      $shm_open("wave.shm");
      $shm_probe("ACTMF");

        $display("=== Exhaustive sign-case TB (ADD_U, TC_SUM, SUB_U) ===");
    $display("format: OPC, a, b, dut(hex), expected(hex), cout, exp_cout, neg, zero, ovf");

    // ---------- CASE A: a=+7, b=+2 ----------
    a = 32'd7; b = 32'd2;

    // ----- OPCODE: unsigned add (a + b) -----
    opcode = 5'b00001;
    #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    expected_cout = temp_sum[WIDTH];
    $display("ADD_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sum, cout, expected_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sum) $display("  ERROR: sum mismatch!");

    // ----- OPCODE: two's complement of (a+b) -----
    opcode = 5'b00010;
    #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    {expected_tc_cout, expected_tc} = (~expected_sum) + 1'b1;
    $display("TC_SUM a=%0d b=%0d -> dut=%h exp=%h (signed %0d) cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_tc, $signed(expected_tc), cout, expected_tc_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_tc) $display("  ERROR: tc sum mismatch!");

    // ----- OPCODE: unsigned sub (a - b) -----
    opcode = 5'b00011;
    #2;
    // implement subtraction expected as a + ~b + 1
    temp_sub = {1'b0, a} + {1'b0, (~b)} + 1'b1;
    expected_sub = temp_sub[WIDTH-1:0];
    expected_sub_cout = temp_sub[WIDTH];
    $display("SUB_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sub, cout, expected_sub_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sub) $display("  ERROR: sub mismatch!");

    // ---------- CASE B: a=-7, b=+2 ----------
    a = -32'sd7; b = 32'd2;

    opcode = 5'b00001; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    expected_cout = temp_sum[WIDTH];
    $display("ADD_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sum, cout, expected_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sum) $display("  ERROR: sum mismatch!");

    opcode = 5'b00010; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    {expected_tc_cout, expected_tc} = (~expected_sum) + 1'b1;
    $display("TC_SUM a=%0d b=%0d -> dut=%h exp=%h (signed %0d) cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_tc, $signed(expected_tc), cout, expected_tc_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_tc) $display("  ERROR: tc sum mismatch!");

    opcode = 5'b00011; #2;
    temp_sub = {1'b0, a} + {1'b0, (~b)} + 1'b1;
    expected_sub = temp_sub[WIDTH-1:0];
    expected_sub_cout = temp_sub[WIDTH];
    $display("SUB_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sub, cout, expected_sub_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sub) $display("  ERROR: sub mismatch!");

    // ---------- CASE C: a=+7, b=-2 ----------
    a = 32'd7; b = -32'sd2;

    opcode = 5'b00001; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    expected_cout = temp_sum[WIDTH];
    $display("ADD_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sum, cout, expected_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sum) $display("  ERROR: sum mismatch!");

    opcode = 5'b00010; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    {expected_tc_cout, expected_tc} = (~expected_sum) + 1'b1;
    $display("TC_SUM a=%0d b=%0d -> dut=%h exp=%h (signed %0d) cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_tc, $signed(expected_tc), cout, expected_tc_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_tc) $display("  ERROR: tc sum mismatch!");

    opcode = 5'b00011; #2;
    temp_sub = {1'b0, a} + {1'b0, (~b)} + 1'b1;
    expected_sub = temp_sub[WIDTH-1:0];
    expected_sub_cout = temp_sub[WIDTH];
    $display("SUB_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sub, cout, expected_sub_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sub) $display("  ERROR: sub mismatch!");

    // ---------- CASE D: a=-7, b=-2 ----------
    a = -32'sd7; b = -32'sd2;

    opcode = 5'b00001; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    expected_cout = temp_sum[WIDTH];
    $display("ADD_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sum, cout, expected_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sum) $display("  ERROR: sum mismatch!");

    opcode = 5'b00010; #2;
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    {expected_tc_cout, expected_tc} = (~expected_sum) + 1'b1;
    $display("TC_SUM a=%0d b=%0d -> dut=%h exp=%h (signed %0d) cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_tc, $signed(expected_tc), cout, expected_tc_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_tc) $display("  ERROR: tc sum mismatch!");

    opcode = 5'b00011; #2;
    temp_sub = {1'b0, a} + {1'b0, (~b)} + 1'b1;
    expected_sub = temp_sub[WIDTH-1:0];
    expected_sub_cout = temp_sub[WIDTH];
    $display("SUB_U  a=%0d b=%0d -> dut=%h exp=%h cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_sub, cout, expected_sub_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_sub) $display("  ERROR: sub mismatch!");

    $display("=== TB finished ===");
    #5;
    $finish;
  end

endmodule

