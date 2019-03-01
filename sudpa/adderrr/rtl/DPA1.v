`timescale 1ns / 1ps

module DPA1(cout,final_sum,a,b,cin,signed_en,negative_flag,overflow_flag,zero_flag);

parameter N=64;

input [N-1:0] a,b;           // inputs
input cin,signed_en;
output reg [N-1:0] final_sum;// outputs
output cout;

wire [N-1:0] p , g;
wire [N:0] c;
wire [N-1:0] sum0 , sum1;
wire [N-1:0] sum;
output reg negative_flag,overflow_flag;
output zero_flag;

//step1 : compute propagate and generate signals

assign p = a ^ b;
assign g = a & b;

//step2 : precompute sums

assign sum0 = p;
assign sum1 = ~(p);


//step2 : compute carry signals

assign c[0] = cin;
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | (p[1] & c[1]);
assign c[3] = g[2] | (p[2] & c[2]);
assign c[4] = g[3] | (p[3] & c[3]);
assign c[5] = g[4] | (p[4] & c[4]);
assign c[6] = g[5] | (p[5] & c[5]);
assign c[7] = g[6] | (p[6] & c[6]);
assign c[8] = g[7] | (p[7] & c[7]);
assign c[9] = g[8] | (p[8] & c[8]);
assign c[10] = g[9] | (p[9] & c[9]);
assign c[11] = g[10] | (p[10] & c[10]);
assign c[12] = g[11] | (p[11] & c[11]);
assign c[13] = g[12] | (p[12] & c[12]);
assign c[14] = g[13] | (p[13] & c[13]);
assign c[15] = g[14] | (p[14] & c[14]);
assign c[16] = g[15] | (p[15] & c[15]);
assign c[17] = g[16] | (p[16] & c[16]);
assign c[18] = g[17] | (p[17] & c[17]);
assign c[19] = g[18] | (p[18] & c[18]);
assign c[20] = g[19] | (p[19] & c[19]);
assign c[21] = g[20] | (p[20] & c[20]);
assign c[22] = g[21] | (p[21] & c[21]);
assign c[23] = g[22] | (p[22] & c[22]);
assign c[24] = g[23] | (p[23] & c[23]);
assign c[25] = g[24] | (p[24] & c[24]);
assign c[26] = g[25] | (p[25] & c[25]);
assign c[27] = g[26] | (p[26] & c[26]);
assign c[28] = g[27] | (p[27] & c[27]);
assign c[29] = g[28] | (p[28] & c[28]);
assign c[30] = g[29] | (p[29] & c[29]);
assign c[31] = g[30] | (p[30] & c[30]);
assign c[32] = g[31] | (p[31] & c[31]);
assign c[33] = g[32] | (p[32] & c[32]);
assign c[34] = g[33] | (p[33] & c[33]);
assign c[35] = g[34] | (p[34] & c[34]);
assign c[36] = g[35] | (p[35] & c[35]);
assign c[37] = g[36] | (p[36] & c[36]);
assign c[38] = g[37] | (p[37] & c[37]);
assign c[39] = g[38] | (p[38] & c[38]);
assign c[40] = g[39] | (p[39] & c[39]);
assign c[41] = g[40] | (p[40] & c[40]);
assign c[42] = g[41] | (p[41] & c[41]);
assign c[43] = g[42] | (p[42] & c[42]);
assign c[44] = g[43] | (p[43] & c[43]);
assign c[45] = g[44] | (p[44] & c[44]);
assign c[46] = g[45] | (p[45] & c[45]);
assign c[47] = g[46] | (p[46] & c[46]);
assign c[48] = g[47] | (p[47] & c[47]);
assign c[49] = g[48] | (p[48] & c[48]);
assign c[50] = g[49] | (p[49] & c[49]);
assign c[51] = g[50] | (p[50] & c[50]);
assign c[52] = g[51] | (p[51] & c[51]);
assign c[53] = g[52] | (p[52] & c[52]);
assign c[54] = g[53] | (p[53] & c[53]);
assign c[55] = g[54] | (p[54] & c[54]);
assign c[56] = g[55] | (p[55] & c[55]);
assign c[57] = g[56] | (p[56] & c[56]);
assign c[58] = g[57] | (p[57] & c[57]);
assign c[59] = g[58] | (p[58] & c[58]);
assign c[60] = g[59] | (p[59] & c[59]);
assign c[61] = g[60] | (p[60] & c[60]);
assign c[62] = g[61] | (p[61] & c[61]);
assign c[63] = g[62] | (p[62] & c[62]);
assign c[64] = g[63] | (p[63] & c[63]);

assign cout = c[N];

//step3 : compute sum[0] signals

assign sum0[0] = p[0];
assign sum0[1] = p[1];
assign sum0[2] = p[2];
assign sum0[3] = p[3];
assign sum0[4] = p[4];
assign sum0[5] = p[5];
assign sum0[6] = p[6];
assign sum0[7] = p[7];
assign sum0[8] = p[8];
assign sum0[9] = p[9];
assign sum0[10] = p[10];
assign sum0[11] = p[11];
assign sum0[12] = p[12];
assign sum0[13] = p[13];
assign sum0[14] = p[14];
assign sum0[15] = p[15];
assign sum0[16] = p[16];
assign sum0[17] = p[17];
assign sum0[18] = p[18];
assign sum0[19] = p[19];
assign sum0[20] = p[20];
assign sum0[21] = p[21];
assign sum0[22] = p[22];
assign sum0[23] = p[23];
assign sum0[24] = p[24];
assign sum0[25] = p[25];
assign sum0[26] = p[26];
assign sum0[27] = p[27];
assign sum0[28] = p[28];
assign sum0[29] = p[29];
assign sum0[30] = p[30];
assign sum0[31] = p[31];
assign sum0[32] = p[32];
assign sum0[33] = p[33];
assign sum0[34] = p[34];
assign sum0[35] = p[35];
assign sum0[36] = p[36];
assign sum0[37] = p[37];
assign sum0[38] = p[38];
assign sum0[39] = p[39];
assign sum0[40] = p[40];
assign sum0[41] = p[41];
assign sum0[42] = p[42];
assign sum0[43] = p[43];
assign sum0[44] = p[44];
assign sum0[45] = p[45];
assign sum0[46] = p[46];
assign sum0[47] = p[47];
assign sum0[48] = p[48];
assign sum0[49] = p[49];
assign sum0[50] = p[50];
assign sum0[51] = p[51];
assign sum0[52] = p[52];
assign sum0[53] = p[53];
assign sum0[54] = p[54];
assign sum0[55] = p[55];
assign sum0[56] = p[56];
assign sum0[57] = p[57];
assign sum0[58] = p[58];
assign sum0[59] = p[59];
assign sum0[60] = p[60];
assign sum0[61] = p[61];
assign sum0[62] = p[62];
assign sum0[63] = p[63];

//step4 : compute sum1 signals
assign sum1[0] = ~(p[0]);
assign sum1[1] = ~(p[1]);
assign sum1[2] = ~(p[2]);
assign sum1[3] = ~(p[3]);
assign sum1[4] = ~(p[4]);
assign sum1[5] = ~(p[5]);
assign sum1[6] = ~(p[6]);
assign sum1[7] = ~(p[7]);
assign sum1[8] = ~(p[8]);
assign sum1[9] = ~(p[9]);
assign sum1[10] = ~(p[10]);
assign sum1[11] = ~(p[11]);
assign sum1[12] = ~(p[12]);
assign sum1[13] = ~(p[13]);
assign sum1[14] = ~(p[14]);
assign sum1[15] = ~(p[15]);
assign sum1[16] = ~(p[16]);
assign sum1[17] = ~(p[17]);
assign sum1[18] = ~(p[18]);
assign sum1[19] = ~(p[19]);
assign sum1[20] = ~(p[20]);
assign sum1[21] = ~(p[21]);
assign sum1[22] = ~(p[22]);
assign sum1[23] = ~(p[23]);
assign sum1[24] = ~(p[24]);
assign sum1[25] = ~(p[25]);
assign sum1[26] = ~(p[26]);
assign sum1[27] = ~(p[27]);
assign sum1[28] = ~(p[28]);
assign sum1[29] = ~(p[29]);
assign sum1[30] = ~(p[30]);
assign sum1[31] = ~(p[31]);
assign sum1[32] = ~(p[32]);
assign sum1[33] = ~(p[33]);
assign sum1[34] = ~(p[34]);
assign sum1[35] = ~(p[35]);
assign sum1[36] = ~(p[36]);
assign sum1[37] = ~(p[37]);
assign sum1[38] = ~(p[38]);
assign sum1[39] = ~(p[39]);
assign sum1[40] = ~(p[40]);
assign sum1[41] = ~(p[41]);
assign sum1[42] = ~(p[42]);
assign sum1[43] = ~(p[43]);
assign sum1[44] = ~(p[44]);
assign sum1[45] = ~(p[45]);
assign sum1[46] = ~(p[46]);
assign sum1[47] = ~(p[47]);
assign sum1[48] = ~(p[48]);
assign sum1[49] = ~(p[49]);
assign sum1[50] = ~(p[50]);
assign sum1[51] = ~(p[51]);
assign sum1[52] = ~(p[52]);
assign sum1[53] = ~(p[53]);
assign sum1[54] = ~(p[54]);
assign sum1[55] = ~(p[55]);
assign sum1[56] = ~(p[56]);
assign sum1[57] = ~(p[57]);
assign sum1[58] = ~(p[58]);
assign sum1[59] = ~(p[59]);
assign sum1[60] = ~(p[60]);
assign sum1[61] = ~(p[61]);
assign sum1[62] = ~(p[62]);
assign sum1[63] = ~(p[63]);

//step5 : final sum calculation

assign sum[0] = c[0] ? sum1[0] : sum0[0];
assign sum[1] = c[1] ? sum1[1] : sum0[1];
assign sum[2] = c[2] ? sum1[2] : sum0[2];
assign sum[3] = c[3] ? sum1[3] : sum0[3];
assign sum[4] = c[4] ? sum1[4] : sum0[4];
assign sum[5] = c[5] ? sum1[5] : sum0[5];
assign sum[6] = c[6] ? sum1[6] : sum0[6];
assign sum[7] = c[7] ? sum1[7] : sum0[7];

assign sum[8] = c[8] ? sum1[8] : sum0[8];
assign sum[9] = c[9] ? sum1[9] : sum0[9];
assign sum[10] = c[10] ? sum1[10] : sum0[10];
assign sum[11] = c[11] ? sum1[11] : sum0[11];
assign sum[12] = c[12] ? sum1[12] : sum0[12];
assign sum[13] = c[13] ? sum1[13] : sum0[13];
assign sum[14] = c[14] ? sum1[14] : sum0[14];
assign sum[15] = c[15] ? sum1[15] : sum0[15];

assign sum[16] = c[16] ? sum1[16] : sum0[16];
assign sum[17] = c[17] ? sum1[17] : sum0[17];
assign sum[18] = c[18] ? sum1[18] : sum0[18];
assign sum[19] = c[19] ? sum1[19] : sum0[19];
assign sum[20] = c[20] ? sum1[20] : sum0[20];
assign sum[21] = c[21] ? sum1[21] : sum0[21];
assign sum[22] = c[22] ? sum1[22] : sum0[22];
assign sum[23] = c[23] ? sum1[23] : sum0[23];

assign sum[24] = c[24] ? sum1[24] : sum0[24];
assign sum[25] = c[25] ? sum1[25] : sum0[25];
assign sum[26] = c[26] ? sum1[26] : sum0[26];
assign sum[27] = c[27] ? sum1[27] : sum0[27];
assign sum[28] = c[28] ? sum1[28] : sum0[28];
assign sum[29] = c[29] ? sum1[29] : sum0[29];
assign sum[30] = c[30] ? sum1[30] : sum0[30];
assign sum[31] = c[31] ? sum1[31] : sum0[31];

assign sum[32] = c[32] ? sum1[32] : sum0[32];
assign sum[33] = c[33] ? sum1[33] : sum0[33];
assign sum[34] = c[34] ? sum1[34] : sum0[34];
assign sum[35] = c[35] ? sum1[35] : sum0[35];
assign sum[36] = c[36] ? sum1[36] : sum0[36];
assign sum[37] = c[37] ? sum1[37] : sum0[37];
assign sum[38] = c[38] ? sum1[38] : sum0[38];
assign sum[39] = c[39] ? sum1[39] : sum0[39];

assign sum[40] = c[40] ? sum1[40] : sum0[40];
assign sum[41] = c[41] ? sum1[41] : sum0[41];
assign sum[42] = c[42] ? sum1[42] : sum0[42];
assign sum[43] = c[43] ? sum1[43] : sum0[43];
assign sum[44] = c[44] ? sum1[44] : sum0[44];
assign sum[45] = c[45] ? sum1[45] : sum0[45];
assign sum[46] = c[46] ? sum1[46] : sum0[46];
assign sum[47] = c[47] ? sum1[47] : sum0[47];

assign sum[48] = c[48] ? sum1[48] : sum0[48];
assign sum[49] = c[49] ? sum1[49] : sum0[49];
assign sum[50] = c[50] ? sum1[50] : sum0[50];
assign sum[51] = c[51] ? sum1[51] : sum0[51];
assign sum[52] = c[52] ? sum1[52] : sum0[52];
assign sum[53] = c[53] ? sum1[53] : sum0[53];
assign sum[54] = c[54] ? sum1[54] : sum0[54];
assign sum[55] = c[55] ? sum1[55] : sum0[55];
assign sum[56] = c[56] ? sum1[56] : sum0[56];
assign sum[57] = c[57] ? sum1[57] : sum0[57];
assign sum[58] = c[58] ? sum1[58] : sum0[58];
assign sum[59] = c[59] ? sum1[59] : sum0[59];
assign sum[60] = c[60] ? sum1[60] : sum0[60];
assign sum[61] = c[61] ? sum1[61] : sum0[61];
assign sum[62] = c[62] ? sum1[62] : sum0[62];
assign sum[63] = c[63] ? sum1[63] : sum0[63];

//step6 : signed and unsigned interpretation and flags 
always@(*)
begin
    if(signed_en && sum[N-1])
    begin
        final_sum = ~(sum[N-1:0])+1;
        negative_flag = signed_en ? sum[N-1] : 1'b0;
        overflow_flag = (a[N-1] & b[N-1] & (~(final_sum[N-1])) |(~(a[N-1])) & (~(b[N-1])) & final_sum[N-1]);

    end
    else
    begin
        final_sum = sum[N-1:0];
        negative_flag = 0;
        overflow_flag = cout;
    end

    

end
assign zero_flag = final_sum == 0;
endmodule






































