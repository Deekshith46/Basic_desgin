module s_box_liner #( parameter XLEN = 8)

                    (input [XLEN-1:0] in,
                     output [XLEN-1:0] out);
                 

                 wire [3:0] b;
                 wire [3:0] c;
                 wire [3:0] q_bar;
                 wire [3:0] e;
                 wire [3:0] f1; 

    
//////////////////////////////////////////ISOMORPHIC MAPPING MODULE////////////////////////////////////////

 assign b[3] =  (in[7] ^ in[5]);
 assign b[2] =  (in[7] ^ in[6] ^ in[4] ^ in[3] ^ in[2] ^ in[1]);
 assign b[1] =  (in[7] ^ in[5] ^ in[3] ^ in[2]);
 assign b[0] =  (in[7] ^ in[5] ^ in[3] ^ in[2] ^ in[1]);

 assign c[3] = (in[7] ^ in[6] ^ in[2] ^ in[1]) ;
 assign c[2] = (in[7] ^ in[4] ^ in[3] ^ in[2] ^ in[1]);
 assign c[1] = (in[6] ^ in[4] ^ in[1]);
 assign c[0] = (in[6] ^ in[1] ^ in[0]);

 assign q_bar = {b,c};

////////////////////////////////////////////////F1 MODULE//////////////////////////////////////////////////

assign e[3] = (b[0] & ~c[3]) ^ (b[1] & ~c[2]) ^ (b[2] & ~c[1]) ^ (c[3] & b[3]) ^ (c[2] & b[3]) ^ (c[0] & b[3]) ^ (c[3] & ~b[3]) ^ (c[3] & b[1]) ^ (c[1] ^ b[3]);
assign e[2] = (~c[2] & b[0]) ^ (~c[1] & b[3]) ^ (c[2] & ~b[2]) ^ (c[0] & b[2]) ^ (c[3] & ~b[3]) ^ (c[3] & b[1]);
assign e[1] = (c[1] & b[0]) ^ (c[0] & b[1]) ^ (c[2] & ~b[2]) ^ (c[1] & ~b[1]) ^ (c[3] & b[2]) ^ (~c[2] & b[3]);
assign e[0] = (c[0] & ~b[0]) ^ (c[1] & ~b[1]) ^ (~c[3] & b[2]) ^ (~c[2] & b[3]) ^ (c[3] & ~b[3]);

assign out = e;
 
endmodule

