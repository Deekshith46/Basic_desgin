[19-04-2025 11:55] Shivprasad Vvp: `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 10:30:24 PM
// Design Name: 
// Module Name: boothalgm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module boothalgm(input  signed [15:0] multiplicand,
    input  signed [15:0] multiplier,
    output reg [255:0] product
);
    reg signed [31:0] partial_products [0:7];  // 8 partial products (since radix-4 halves the number of steps)
    integer i;

    always @(*) begin
        // Initialize partial products
        for (i = 0; i < 8; i = i + 1)
            partial_products[i] = 0;

        // Booth Encoding and Multiplication
        for (i = 0; i < 8; i = i + 1) begin
            case ({multiplier[2*i+1], multiplier[2*i], (i == 0 ? 1'b0 : multiplier[2*i-1])})  // Booth Encoding
                3'b000, 3'b111: partial_products[i] = 0;                    // 0 * M
                3'b001, 3'b010: partial_products[i] = multiplicand;         // +1 * M
                3'b011:          partial_products[i] = multiplicand << 1;   // +2 * M
                3'b100:          partial_products[i] = -(multiplicand << 1);// -2 * M
                3'b101, 3'b110:  partial_products[i] = -multiplicand;       // -1 * M
            endcase
            
            // Shift left for next partial product placement
            partial_products[i] = partial_products[i] << (2 * i);
        end
    end

    // Sum all partial products
    always@(*)
    begin
    
     product = {partial_products[0] , partial_products[1] , partial_products[2] ,
                     partial_products[3] , partial_products[4] , partial_products[5] ,
                     partial_products[6] , partial_products[7]};
   
    end
endmodule
[19-04-2025 11:55] Shivprasad Vvp: `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 10:34:22 PM
// Design Name: 
// Module Name: fastadderrr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fastadderrr(
    input  [31:0] A, B,  // 32-bit inputs
    input  Cin,          // Carry-in
    output [31:0] Sum,   // 32-bit Sum
    output Cout          // Carry-out
);
    wire [31:0] P, G;    // Propagate & Generate
    wire [32:0] Carry;   // Internal carry wires

    // Generate (G) and Propagate (P) signals
    assign P = A ^ B; // Propagate: P = A ⊕ B
    assign G = A & B; // Generate: G = A & B

    // Carry Lookahead Logic (Parallel Carry Computation)
    assign Carry[0]  = Cin;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign Carry[i+1] = G[i] | (P[i] & Carry[i]);
        end
    endgenerate

    // Sum Calculation
    assign Sum = P ^ Carry[31:0];

    // Final Carry-Out
    assign Cout = Carry[32];




endmodule
[19-04-2025 11:55] Shivprasad Vvp: `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 10:36:33 PM
// Design Name: 
// Module Name: datapath0001
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath0001(

   input  signed [15:0] multiplicand,
   input  signed [15:0] multiplier,
   output signed [31:0] product, 
   output carryout);
   
   wire [255:0]pp;
   wire [31:0]finallsum,finnallcarry;
   
   assign carrin=0;

boothalgm bth( multiplicand,multiplier,pp);
wallactreeee walt(pp,finallsum,finnallcarry);
fastadderrr fsa(finallsum,finnallcarry,carrin,product,carryout);


endmodule
[19-04-2025 11:55] Shivprasad Vvp: `timescale 1ns / 1ps



module wallactreeee(
    input [127:0] pp,   // Partial Products from Modified Booth
    output [29:0] sumlast1,
    output [23:0] sumlast2
);  

    // Splitting 128-bit input into 8 parts (each 16 bits)
    wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;
    assign {pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7} = pp;

   wire [15:0] sumstage1, sumstage2;
   wire [16:0] sumstage3;
   wire [15:0] sumstage4;
   wire [20:0] sumstage5;
   wire [23:0] sumstage6;
   
   wire [15:0]carrystage1, carrystage2;
   wire [16:0] carrystage3;
   wire [15:0] carrystage4;
   wire [20:0] carrystage5;
   wire [23:0] carrystage6;


//  STAGE 1

         full_adder1   fa001 (pp0[15:4],pp1[13:2],pp2[11:0],sumstage1[13:2],carrystage1[13:2]);
         half_adder1 ha001(pp0[3:2],pp1[1:0],sumstage1[1:0],carrystage1[1:0]);
         half_adder1 ha002(pp1[15:14],pp2[13:12],sumstage1[15:14],carrystage1[15:14]);

// STAGE2 2
         full_adder1   fa002(pp3[15:4],pp4[13:2],pp5[11:0],sumstage2[13:2],carrystage2[13:2]);
         half_adder1 ha003(pp3[3:2],pp4[1:0],sumstage2[1:0],carrystage2[1:0]);         
         half_adder1 ha004(pp3[15:14],pp4[13:12],sumstage2[15:14],carrystage2[15:14]);

// STAGE 3
                                                                                  

        full_adder3 fa003({carrystage1[15],sumstage1[15:4]},{pp2[14],carrystage1[14:3]},{sumstage2[10:0],pp3[1:0]},sumstage3[15:3],carrystage3[15:3]);
        half_adder2 ha007(pp2[15],sumstage2[11],sumstage3[16],carrystage3[16]);
        half_adder3 ha008(sumstage1[3:1],carrystage1[2:0],sumstage3[2:0],carrystage3[2:0]);

//STAGE 4
     
        full_adder1 fa004({pp5[15:14],carrystage2[14:5]},pp6[13:2],pp7[11:0],sumstage4[13:2],carrystage4[13:2]);
        half_adder1 ha009(carrystage2[4:3],pp6[1:0],sumstage4[1:0],carrystage4[1:0]);
        half_adder1 ha0010(pp6[15:14],pp7[13:12],sumstage4[15:14],carrystage4[15:14]);
//STAGE 5

       full_adder1 fa005({carrystage3[16],sumstage3[16:6]},{sumstage2[12],carrystage4[15:5]},{sumstage4[8:0],carrystage2[2:0]},sumstage5[16:5],carrystage5[16:5]);
       half_adder4 ha0011({carrystage2[15],sumstage2[15:13]},sumstage4[12:9],sumstage5[20:17],carrystage5[20:17]);     
       half_adder6 ha0012(sumstage3[5:1],carrystage3[4:0],sumstage5[4:0],carrystage5[4:0]);     

//STAGE 6

       full_adder3 fa006({carrystage5[20],sumstage5[20:9]},{sumstage4[13],carrystage5[19:8]},carrystage4[12:0],sumstage6[20:8],carrystage6[20:8]);
       half_adder3 ha0013({carrystage4[15],sumstage4[15:14]},{pp7[14],carrystage4[14:13]},sumstage6[23:21],carrystage6[23:21]); 
       half_adder5 ha0014(sumstage5[8:1],carrystage5[7:0],sumstage6[7:0],carrystage6[7:0]);



assign sumlast1={carrystage6[23],sumstage6[23:0],sumstage5[0],sumstage3[0],sumstage1[0],pp0[1:0]};
assign sumlast2={pp7[15],carrystage6[22:0]};



endmodule






module full_adder1(
    input  [11:0] a, b,cin,
    output [11:0] sum,
    output  [11:0]carry
);
    assign sum = a ^ b^cin;
    assign carry = a & b|cin&(a ^ b);
    
endmodule

module full_adder3(
    input  [12:0] a, b,cin,
    output [12:0] sum,
    output  [12:0]carry
);
    assign sum = a ^ b^cin;
    assign carry = a & b|cin&(a ^ b);
    
endmodule




module half_adder1(
    input  [1:0] a, b,
    output [1:0] sum,
    output  [1:0]carry
);
    assign sum = a ^ b;
    assign carry = a & b;
    
endmodule

module half_adder2(
    input   a, b,
    output  sum,
    output  carry
);
    assign sum = a ^ b;
    assign carry = a & b;
    
endmodule



module half_adder3(
    input  [2:0] a, b,
    output [2:0] sum,
    output  [2:0]carry
);
    assign sum = a ^ b;
    assign carry = a & b;
     
endmodule   
  
  
module half_adder4(
    input  [3:0] a, b,
    output [3:0] sum,
    output  [3:0]carry
);
    assign sum = a ^ b;
    assign carry = a & b;
     
endmodule  


module half_adder6(
    input  [4:0] a, b,
    output [4:0] sum,
    output  [4:0]carry
);
    assign sum = a ^ b;
    assign carry = a & b;
     
endmodule






module half_adder5(
    input  [7:0] a, b,
    output [7:0] sum,
    output  [7:0]carry
);
    assign sum = a ^ b;
    assign carry = a & b;
     
endmodule
