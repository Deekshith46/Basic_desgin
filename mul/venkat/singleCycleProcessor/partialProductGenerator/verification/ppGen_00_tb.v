module tb_ppGenTB;
    reg sign, one, two;
    reg  [31:0] x;
    wire [31:0] pp;
    wire carry;

    partial_product uut (.sign(sign), .one(one), .two(two), .x(x), .pp(pp), .carry(carry));

    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
    end
    integer i;

    initial begin
	$monitor("Input value = %h",x);
        $monitor("Time = %0t  sign = %b one = %b two = %b  pp = %h  carry = %b", $time, sign, one, two, pp, carry);

        x=32'h0000110f;
	sign=0; one=0; two=0; #10;
	sign=0; one=0; two=1; #10;
	sign=0; one=1; two=0; #10;
	sign=0; one=1; two=1; #10;
	sign=1; one=0; two=0; #10;
	sign=1; one=0; two=1; #10;
	sign=1; one=1; two=0; #10;
	sign=1; one=1; two=1; #10;

        $finish;
    end
endmodule
