//Design :- Vending machine
//Desiner :- Deekshith H P
//Date    :- 27/01/2025

module tb_vending;
reg clk;
reg rst;
reg [1:0] coin_in ;    // 2bit 1,2,3
reg [2:0] select_item; // 6 item
reg cancel;
wire dispense;
wire return_change;

vending dut1(clk,rst,coin_in,select_item,dispense,return_change,cancel);

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
end

always begin
    clk =0;
    forever #5 clk = ~clk; 
end

initial begin
    rst = 1'b0;
#5
rst = 1'b1;
coin_in = 2'b11;
select_item = 3'b001;
cancel = 0;
#30
coin_in = 2'b01;
select_item = 3'b001;
cancel = 0;

#30
coin_in = 2'b11;
select_item = 3'b101;
cancel = 0;
#30
coin_in = 2'b11;
select_item = 3'b010;
cancel = 0;

#200;
$finish();
end
endmodule
