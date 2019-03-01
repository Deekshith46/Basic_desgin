module tb_ppGenTB;
    reg [31:0] op2;
    reg s_or_us;
    wire [16:0] one;
    wire [16:0] two;
    wire [16:0] sign;

    booth uut (.op2(op2), .s_or_us(s_or_us), .one(one), .two(two), .sign(sign));

    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
    end
    integer i;

    initial begin
        $monitor("Time = %0t  input = %h  signed or unsigned = %b  sign = %h one = %h two = %h  ", $time, op2, s_or_us, sign, one,two);
	s_or_us = 0;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
	s_or_us = 1;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
        op2=$random; #10;
        $finish;
    end
endmodule

