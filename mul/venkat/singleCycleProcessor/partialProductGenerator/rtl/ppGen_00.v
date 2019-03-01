module partial_product (
	input wire sign, one, two,
	input wire [31:0] x,
	output wire carry,
	output wire [31:0] pp
);

	genvar i;
	generate
		for(i = 0 ; i < 32 ; i = i+1) begin
			wire a0, a1, xr0, c0;
			assign c0 = (i==0) ? 0 : x[i-1] ;
			assign a0 = c0 & two ;
			assign a1 = x[i] & one ;
			assign xr0 = a0 | a1 ;
			assign pp[i] = sign ^ xr0 ;
			assign carry = (i == 31) ? (sign & xr0) : 0;
		end
	endgenerate
endmodule
