//Design :- Vending machine
//Desiner :- Deekshith H P
//Date    :- 27/01/2025

module vending(clk,rst,coin_in,select_item,dispense,return_change,cancel);
input clk;
input rst;
input [1:0] coin_in ;    // 2bit 1,2,3
input [2:0] select_item; // 6 item
input cancel;
output reg dispense;
output reg return_change;
//output reg error;

parameter idle = 3'b000;
parameter money_insert = 3'b001;
//parameter item_select  = 3'b010;
parameter dispense_item = 3'b010;
parameter change_return = 3'b011;
//parameter error         = 3'b101;

reg[3:0] present_state , next_state;

reg[2:0] price_item;
reg [2:0] balance=0;

always@(*) begin


        case(select_item)
            3'b000 : price_item = 3'b001;
            3'b001 : price_item = 3'b010;
            3'b010 : price_item = 3'b011;
            3'b011 : price_item = 3'b100;
            3'b100 : price_item = 3'b101;
            3'b101 : price_item = 3'b110;
            3'b110 : price_item = 3'b111;
            3'b111 : price_item = 3'b000;
            default : price_item = 3'b000;
        endcase
end

always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            present_state <= idle;
        end
        else 
        begin
            present_state <= next_state;
        end
    end

always@(present_state or coin_in)
    begin
    //balance = 0;
    case(present_state)

        idle : begin
            balance =0;
            return_change =0;
            if(coin_in > 0) begin
                next_state = money_insert;
                
            end
            else if(cancel) begin
                next_state = idle;
            end
            else begin
                next_state = idle;
              
            end
        end

        money_insert :  begin

            balance = balance + coin_in;

            if(select_item > 0 ) begin
                if(balance == price_item) begin
                    next_state = dispense_item;
                    return_change = 1'b0;
                    
                end

                else if(balance > price_item)begin
                    next_state = dispense_item;                    
                end

                else if(balance < price_item)begin
                    next_state = idle;
                    dispense =1'b0;
                end

                else begin
                    next_state =money_insert;
                end

            end
        end
        
        dispense_item : begin
            dispense = 1'b1;  
            if(balance > price_item) begin
                balance = balance - price_item;
                next_state = change_return;
            end
            else begin
                next_state = idle;
            end
        end
        
        change_return : begin
            return_change = 1;
            balance = 0;
            next_state = idle;
        end
        default : next_state = idle;
    endcase
    end     
    endmodule
