module tb;
reg clk_tb;
reg mod_tb;
reg rst_tb;
wire [2:0] count_tb;

logic [2:0] sco_output;

counter dut(.clk(clk_tb),
            .rst(rst_tb),
            .mod(mod_tb),
            .count(count_tb));

always begin
clk_tb = 0;
forever #5 clk_tb = ~clk_tb;
end

initial begin
#5
rst_tb = 1'b1;
#10
rst_tb = 1'b0;
#15
mod_tb = 1'b1;
#250
mod_tb = 1'b0;
#1000;
$finish();
end

///////////scoreboard///////

always@(posedge clk_tb)
    begin
        if(rst_tb)begin
            sco_output <= 3'b000;
        end
        else begin
            if(mod_tb)begin
            sco_output  <= sco_output  +1;
            end
            else begin
            sco_output <= sco_output -1;
            end
        end
    end

always@(posedge clk_tb) begin
    if(count_tb == sco_output) begin
        $display("MATCH at time = %0t,\tmod = %0d ,\trtl_output = %0d,\tsco_output = %0d", $time,mod_tb,count_tb,sco_output);
end
    else begin
         $display("MISSMATCH at time = %0t,\tmod = %0d\trtl_output = %0d,\tsco_output = %0d", $time,mod_tb,count_tb,sco_output);
        end
end

///coverage//
/*covergroup abc;
A: coverpoint mod_tb
{
 bins bin_0={0};
 bins bin_1={1};

}
B:coverpoint clk_tb
{
 bins bin_0={0};
 bins bin_1={1};
}
}
C:coverpoint rst_tb
{
 bins bin_0={0};
 bins bin_1={1};
}
endgroup:abc
abc abc_h;
initial begin
abc_h=new();
repeat(300)
begin
#5
abc_h.sample();

end
end*/


endmodule


