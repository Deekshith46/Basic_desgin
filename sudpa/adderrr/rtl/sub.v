module sub #(parameter WIDTH =32)
(
input [WIDTH-1:0] a,
input [WIDTH-1:0] b,
input cin,
output  [WIDTH-1:0] final_out
);

wire [WIDTH-1:0] b_ext;

assign b_ext = ~b;

    


DPA1 #(WIDTH) subreuse(.a(a),
              .b(b_ext),
              .cin(cin),
              .final_out(final_out));

endmodule

