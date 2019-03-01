`timescale 1ns / 1ps

module DPA(cout,sum,a,b,cin,negative_flag,zero_flag,overflow_flag,signed_sum,unsigned_sum,mode);

parameter N=8;
https://github.com/Chandan-0307/adder.git
input [N-1:0] a,b;
input cin;
input mode;
output [N-1:0] sum;
output cout;
output reg [N-1:0] signed_sum,unsigned_sum;
output reg negative_flag,overflow_flag;
output zero_flag;


wire [N-1:0] p,g;
wire [N-1:0] sum0,sum1;
wire [N:0] c;

//wire signed_flag,negative_flag,zero_flag;

assign p = a ^ b;  //propagate signals
assign g = a & b;  //generate signals

//assign sum0 = p;
//assign sum1 = ~(p);

assign sum0[0] = p[0];
assign sum0[1] = p[1];
assign sum0[2] = p[2];
assign sum0[3] = p[3];
assign sum0[4] = p[4];
assign sum0[5] = p[5];
assign sum0[6] = p[6];
assign sum0[7] = p[7];

assign sum1[0] = ~(p[0]);
assign sum1[1] = ~(p[1]);
assign sum1[2] = ~(p[2]);
assign sum1[3] = ~(p[3]);
assign sum1[4] = ~(p[4]);
assign sum1[5] = ~(p[5]);
assign sum1[6] = ~(p[6]);
assign sum1[7] = ~(p[7]);


//carry generation

assign c[0] = cin;
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | (p[1] & c[1]);
assign c[3] = g[2] | (p[2] & c[2]);
assign c[4] = g[3] | (p[3] & c[3]);
assign c[5] = g[4] | (p[4] & c[4]);
assign c[6] = g[5] | (p[5] & c[5]);
assign c[7] = g[6] | (p[6] & c[6]);
assign c[8] = g[7] | (p[7] & c[7]);
//assign c[9] = g[8] | (p[8] & c[8]);
//assign c[10] = g[9] | (p[9] & c[9]);
//assign c[11] = g[10] | (p[10] & c[10]);
//assign c[12] = g[11] | (p[11] & c[11]);
//assign c[13] = g[12] | (p[12] & c[12]);
//assign c[14] = g[13] | (p[13] & c[13]);
//assign c[15] = g[14] | (p[14] & c[14]);
//assign c[16] = g[15] | (p[15] & c[15]);
//assign c[17] = g[16] | (p[16] & c[16]);
//assign c[18] = g[17] | (p[17] & c[17]);
//assign c[19] = g[18] | (p[18] & c[18]);
//assign c[20] = g[19] | (p[19] & c[19]);
//assign c[21] = g[20] | (p[20] & c[20]);
//assign c[22] = g[21] | (p[21] & c[21]);
//assign c[23] = g[22] | (p[22] & c[22]);
//assign c[24] = g[23] | (p[23] & c[23]);
//assign c[25] = g[24] | (p[24] & c[24]);
//assign c[26] = g[25] | (p[25] & c[25]);
//assign c[27] = g[26] | (p[26] & c[26]);
//assign c[28] = g[27] | (p[27] & c[27]);
//assign c[29] = g[28] | (p[28] & c[28]);
//assign c[30] = g[29] | (p[29] & c[29]);
//assign c[31] = g[30] | (p[30] & c[30]);
//assign c[32] = g[31] | (p[31] & c[31]);

assign cout = c[N];

// Final sum calculation

assign sum[0] = c[0] ? sum1[0] : sum0[0];
assign sum[1] = c[1] ? sum1[1] : sum0[1];
assign sum[2] = c[2] ? sum1[2] : sum0[2];
assign sum[3] = c[3] ? sum1[3] : sum0[3];
assign sum[4] = c[4] ? sum1[4] : sum0[4];
assign sum[5] = c[5] ? sum1[5] : sum0[5];
assign sum[6] = c[6] ? sum1[6] : sum0[6];
assign sum[7] = c[7] ? sum1[7] : sum0[7];

//assign sum = c ? sum1 : sum0;


// Flags

always@(*)
begin
    if(mode == 1)
    begin
        signed_sum = ~(sum[N-1:0])+1;
        unsigned_sum = 0;
        negative_flag = sum[7];
        overflow_flag = (a[N-1] & b[N-1] & (~(sum[N-1])) |(~(a[N-1])) & (~(b[N-1])) & sum[N-1]);
    end
    else
    begin
        signed_sum = 0;
        unsigned_sum = sum[N-1:0];
        negative_flag = sum[7];
        overflow_flag = cout;
    end


    
end
        
assign zero_flag = (sum == 0);


//assign signed_flag = sum[N-1];
//assign negative_flag = sum[N-1];
//assign zero_flag = (sum == 0);
//assign overflow_flag = (a[N-1] & b[N-1] & (~(sum[N-1])) |(~(a[N-1])) & (~(b[N-1])) & sum[N-1]);
//assign overflow_flag = a[N-1:0] ^ b[N-1:0];

endmodule

