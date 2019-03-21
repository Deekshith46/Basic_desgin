module testbench;
logic clk_tb;
logic mod_tb;
logic rst_tb;
logic [2:0] count_tb;

logic clk;
logic mod;
logic rst;

counter dut(.clk(clk_tb),
            .mod(mod_tb),
            .rst(rst_tb),
            .count(count_tb));


initial begin 
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

always begin
    clk_tb =0;
    forever #5 clk_tb = ~clk_tb;
end

initial begin
#5
rst_tb = 1'b1;
#10;
rst_tb = 1'b0;
    
    #5
    mod_tb = 1'b1;
    #500
    mod_tb = 1'b0;
        end

//////////// scoreboard///////////
 

    always@(posedge clk_tb)
        begin
            if(rst_tb)
            begin
                count_tb = 3'b000;
                end

            else 
            begin
                if(mod_tb)
                begin
                    count_tb = count_tb +1;
                end
                else
                begin
                    count_tb = count_tb -1;
                end                
            end    
        end


       initial begin
       logic count;
                if(count == counter_tb)
                    $display("COUNTER IS MATCHED");
                   else
                       $display("COUNTER IS NOT MATCHED");

        end

        initial begin
        #1000;
        $finish();
        end
endmodule

