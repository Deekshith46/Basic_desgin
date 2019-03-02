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

  initial begin
    $dumpfile("tb_all_cases.vcd");
    $dumpvars(0, tb_all_cases);

    $display("=== Exhaustive sign-case TB ===");
    $display("Testing cases for opcodes: ADD_U (00001) and TC_SUM (00010)");
    $display("format: OPC, a, b, final_sum(hex), expected(hex), cout, expected_cout, neg, zero, ovf");

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
    // compute expected two's-complement of the unsigned sum
    // use intermediate width to detect carry-out
    temp_sum = {1'b0, a} + {1'b0, b};
    expected_sum = temp_sum[WIDTH-1:0];
    {expected_tc_cout, expected_tc} = (~expected_sum) + 1'b1;
    $display("TC_SUM a=%0d b=%0d -> dut=%h exp=%h (signed %0d) cout=%b exp_cout=%b neg=%b zero=%b ovf=%b",
              $signed(a), $signed(b), final_sum, expected_tc, $signed(expected_tc), cout, expected_tc_cout, negative_flag, zero_flag, overflow_flag);
    if (final_sum !== expected_tc) $display("  ERROR: tc sum mismatch!");

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

    $display("=== TB finished ===");
    #5;
    $finish;
  end

endmodule

