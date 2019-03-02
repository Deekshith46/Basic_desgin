`timescale 1ns /1ps
module sub #(parameter WIDTH =32)
(
input [WIDTH-1:0] a,
input [WIDTH-1:0] b,
input cin,
input signed_en,
output  [WIDTH-1:0] final_out,
output cout,
output zero_flag,
output negative_flag,
output overflow_flag

);

wire [WIDTH-1:0] b_ext ;

assign b_ext = ~b ;

DPA1 #(.N(WIDTH))  subreuse(.a(a),
               .b(b_ext),
               .cin(cin),
               .signed_en(signed_en),
               .final_sum(final_out),
               .cout(cout),
               .zero_flag(zero_flag),
               .negative_flag(negative_flag),
               .overflow_flag(overflow_flag));
endmodule

