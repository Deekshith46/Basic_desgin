module tb;
reg clk,rst,x;
wire out;

seq_det dut(.clk(clk),
        .rst(rst),
        .x(x),
        .out(out));

always begin
    clk =0;
    forever #5 clk = ~clk;
end

initial
begin
x = 1'b0    ;
rst = 1'b0  ;
end

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial begin
#10;
rst =1;
#10;
rst =1;
#15;
x = 1;
#10;
x = 0;
#10 ;
x = 1;
#10;
x = 0;
#10;
x= 1;
#10;
x=0;
#1000;
$finish();
end
endmodule
