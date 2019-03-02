`timescale 1ns/1ps

module tb_sub;

  parameter WIDTH = 8;   // keep small for easy viewing
  reg  [WIDTH-1:0] a, b;
  reg              cin;
  reg              signed_en;
  wire [WIDTH-1:0] final_out;
  wire             cout;
  wire             zero_flag;
  wire             negative_flag;
  wire             overflow_flag;

  // Instantiate the DUT
  sub #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .cin(cin),
    .signed_en(signed_en),
    .final_out(final_out),
    .cout(cout),
    .zero_flag(zero_flag),
    .negative_flag(negative_flag),
    .overflow_flag(overflow_flag)
  );

  initial begin
    $display(" time |   a   |   b   | cin | signed | result | cout z  n  ov");
    $monitor("%4t |    %4d  | %4d   |  %b |   %b   | %4d   |  %b   %b %b %b",
             $time, a, b, cin, signed_en, final_out,
             cout, zero_flag, negative_flag, overflow_flag);

    // Case 1: 5 - 3 = 2
    a = 8'd5; b = 8'd3; cin = 1'b1; signed_en = 1'b0;
    #10;

    // Case 2: 3 - 5 = -2 (unsigned borrow, signed negative)
    a = 8'd3; b = 8'd5; cin = 1'b1; signed_en = 1'b0;
    #10;

    // Case 3: signed subtraction with negative result
    a = -8'sd10; b = 8'sd20; cin = 1'b1; signed_en = 1'b1;
    #10;

    // Case 4: overflow check (127 - (-1) for 8-bit signed)
    a = 8'd127; b = -8'sd1; cin = 1'b1; signed_en = 1'b1;
    #10;

    $finish;
  end

endmodule

