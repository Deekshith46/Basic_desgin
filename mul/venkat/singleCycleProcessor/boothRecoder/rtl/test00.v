module booth(
	input wire [31:0] op2,
	input s_or_us,
	output wire [16:0] one,
	output wire [16:0] two,
	output wire [16:0] sign
);
wire [33:0] y;
/*
if (s_or_us == 1) begin // for signed
	assign y = { {2{op2[31]}}, op2 };
end
else begin
	assign y = { 2'b00 , op2 };
end
always @(*) begin
    if (s_or_us == 1) begin
	y = { {2{op2[31]}}, op2 }; // signed logic here
    end else begin
	y = { 2'b00 , op2 }; // unsigned logic here
    end
end
*/

assign y = (s_or_us == 1) ? { {2{op2[31]}}, op2 } : { 2'b00 , op2 } ;
integer j;
genvar i;
generate
	for (i = 0; i <= 32 ; i = i+2) begin
		wire wireNOT, wireXOR, wireCONDITION;
		assign wireCONDITION = (i == 0) ? 0 : y[i-1];
		assign one[i] =  wireCONDITION ^ y[i];
		assign wireNOT = ~one[i];
		assign wireXOR = y[i] ^ y[i+1];
		assign two[i] = wireNOT & wireXOR ;
		assign sign[i] = y[i+1];
	end
endgenerate
endmodule
