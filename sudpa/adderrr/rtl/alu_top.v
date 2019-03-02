`timescale 1ns/1ps
module top#(
           parameter WIDTH = 32,
           parameter OP_LEN = 5
        
)
(   
        input [WIDTH-1:0] a,
        input [WIDTH-1:0] b,
        input [OP_LEN -1 :0 ] opcode,
        output reg [WIDTH-1:0] final_sum,
        output reg cout,
        output reg negative_flag,
        output reg overflow_flag,
        output reg zero_flag
);

wire [WIDTH-1:0] unsigned_o;
wire cout_ab,neg_ab,ovf_ab,z_ab;

 /////////////////////unsigned/////////////////////////
dpa1 #(.WIDTH(WIDTH)) add_un(
                              .a(a),
                              .b(b),
                              .cin(1'b0),
                              .final_sum(unsigned_o),
                              .cout(cout_ab),
                              .negative_flag(neg_ab),
                              .overflow_flag(ovf_ab),
                              .zero_flag(z_ab));

////////////////////////signed////////////////////
wire [WIDTH-1:0] sum_sing;
wire cout_sing,neg_sing,ovf_sing,z_sing;

dpa1 #(.WIDTH(WIDTH)) add_sin(.a(~unsigned_o),
                              .b({WIDTH{1'b0}}),
                              .cin(1'b1),
                              .final_sum(sum_sing),
                              .cout(cout_sing),
                              .negative_flag(neg_sing),
                              .overflow_flag(ovf_sing),
                              .zero_flag(z_sing));

////////////////////////SUB//////////////////////////////
wire [WIDTH-1 : 0] sub_out;
wire cout_sub,neg_sub,ovf_sub,z_sub;

dpa1 #(.WIDTH(WIDTH)) sub (.a(a),
                           .b(~b),
                           .cin(1'b1),
                           .final_sum(sub_out),
                           .cout(cout_sub),
                           .negative_flag(neg_sub),
                           .overflow_flag(ovf_sub),
                           .zero_flag(z_sub));
                          
always@(*) begin
    case(opcode)
        5'b00001 : 
                    begin
                        final_sum = unsigned_o;
                        zero_flag = z_ab;
                        overflow_flag = ovf_ab;
                        negative_flag = unsigned_o[WIDTH-1];
                        cout = cout_ab;                        
                    end
 
        5'b00010 :
                    begin
                        final_sum = sum_sing;
                        zero_flag = z_sing;
                        overflow_flag = ovf_sing;
                        cout = cout_sing;
                        negative_flag = final_sum[WIDTH-1];
                    end
        5'b00011 : 
                    begin
                        final_sum = sub_out;
                        zero_flag = z_sub;
                        overflow_flag = ovf_sub;
                        cout = cout_sub;
                        negative_flag = final_sum[WIDTH-1];
                    end
    endcase
end
endmodule       

           




