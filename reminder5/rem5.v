
module rem5(clk,rst,x,out);
input clk,rst,x;
output out;

parameter s0 = 3'b000;
parameter s1 = 3'b001;
parameter s2 = 3'b010;
parameter s3 = 3'b011;
parameter s4 = 3'b100;

reg[2:0] present_state , next_state;

assign out = (present_state == s0);

always@(posedge clk or negedge rst)
            begin
                if(!rst)
                begin
                    present_state <= s0;
                end
                else
                begin
                    present_state <= next_state;
                end
            end
always@(*) 
        begin
            case(present_state)
                s0: begin
                    if(x)begin
                        next_state = s1;
                        //out = 1'b0;
                    end
                    else begin
                        next_state = s0;
                       // out = 1'b1;
                    end
                end

                s1: begin
                    if(x)begin
                        next_state = s3;
                       // out = 1'b0;
                    end
                    else begin
                        next_state = s2;
                        //out = 1'b0;
                    end
                end

                s2: begin
                    if(x)begin
                        next_state = s0;
                       // out = 1'b1;
                    end
                    else begin
                        next_state = s4;
                        //out = 1'b0;
                    end
                end
                
                s3: begin
                    if(x)begin
                        next_state = s2;
                       // out = 1'b0;
                    end
                    else begin
                        next_state = s1;
                       // out = 1'b0;
                    end
                end
                
                s4: begin
                    if(x)begin
                        next_state = s4;
                        //out = 1'b0;
                    end
                    else begin
                        next_state = s3;
                       // out = 1'b0;
                    end
                end


            endcase
        end           
            endmodule
