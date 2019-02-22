
//////Design :- Reminder of 3 ///////////
////Designer :- Deekshith H P //////////
////Date     :- 22-01-2025    /////////


module rem(clk,rst,x,out)                       ;
input clk,rst,x                                 ;
output reg  out                                 ;

parameter a= 2'b00                              ;
parameter b = 2'b01                             ;
parameter c = 2'b10                             ;

reg[1:0] present_state, next_state              ;

always@(posedge clk or negedge rst ) begin
    if(!rst)
    begin
        present_state <=  a                     ;
    end
    else begin
        present_state <=  next_state            ;
    end
end

always@(*)
begin
        case(present_state)
        a:begin
            if(x==0)begin
                next_state =  a                 ;
               out = 1'b1                       ;
            end
            else begin
                next_state = b                  ;
                out =1'b0                       ;
            end
        end

        b:begin
            if(x==0)begin
                next_state =  c                 ;
               out =1'b0                        ;

            end
            else begin
                next_state = a                  ;
                out =1'b1                       ;

            end
        end

        c:begin
            if(x==0)begin
                next_state =  b                 ;
                out =1'b0                       ;

            end
            else begin
                next_state =  c                 ;
                out =1'b0                       ;

            end
        end
        default : begin next_state = a          ;
                        out = 1'b0              ;
                    end
    endcase
end


endmodule
