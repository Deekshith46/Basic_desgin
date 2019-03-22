module testbench;
logic clk_tb;
logic mod_tb;
logic rst_tb;
logic [2:0] count_tb;

logic [2:0] sco_count;

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
#5;
rst_tb = 1'b1;
#10;
rst_tb = 1'b0;
#20;
mod_tb = 1'b1;
#100;
mod_tb = 1'b0;
#200;
$finish();
end

//////////// scoreboard///////////
 

    always@(posedge clk_tb)
        begin
            if(rst_tb)
            begin
                sco_count = 3'b000;
                end

            else 
            begin
                if(mod_tb)
                begin

#10;
                    sco_count = sco_count +1;
                end
                else
                begin
          #10;
                    sco_count = sco_count -1;
                end                
            end    
        end

       always@(posedge clk_tb) begin
                repeat(1)begin
                if(count_tb == sco_count)begin
                    $display("Match at time %0f : rtl output = %0d , sco output = %0d",$time,count_tb,sco_count);
                    end
                   else begin
                    $display("NOTMatch at time %0f : rtl output = %0d , sco output = %0d",$time,count_tb,sco_count);                     
        end
        end
      end
    

        /*initial begin
        #1000;
        $finish();
        end*/
endmodule

