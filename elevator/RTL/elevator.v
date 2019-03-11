module elevator(clk,rst,floor_req , current_floor, direction , door_open)   ; // port delcaration
input      clk,rst                                                          ; // input clock and reset
input[2:0] floor_req                                                        ; // floor_request (001 = floor0, 010 = floor1 , 100 = floo2)
input[1:0] current_floor                                                    ; // current_floor (00=0th,01=1st,10=2nd)
output reg direction                                                        ; // directio 1 up and 0 down
output reg door_open                                                        ; // door open 1 is open and 0 close

parameter idle       = 2'b00                                                ; // 4state idle
parameter move_up    = 2'b01                                                ; // move up
parameter move_down  = 2'b10                                                ; // move down
parameter open_door  = 2'b11                                                ; // open door

reg[1:0] present_state , next_state                                         ; //register to move  

always@(posedge clk or posedge rst) begin
    if(!rst) begin
        present_state  <= idle                                              ; // if reset is low initial state is idle
    end
    else begin
        present_state <= next_state                                         ; // if reset is high it will movw to next state
    end
end

always@* begin
        next_state = present_state                                          ; //initializing 
        direction = 0                                                       ;
        door_open = 0                                                       ;
    
        case(present_state)
        idle : begin                                                          // Idle state
            if(floor_req == 3'b000) begin                                     //if req is 0 then idle state
                next_state = idle                                           ;
            end

            else if(floor_req[2] && current_floor < 2) begin                  // else if request for 2nd floor and the floor is 
             direction = 1'b1                                               ; // less than 2 it move to 2nd floor                      
             next_state = move_up                                           ; // state is up

        end

        else if (floor_req[1] && current_floor < 1)begin                      // else if request for 1st floor and the floor is                   
            next_state = move_up                                            ; // less than 1 it move to 1nd floor
            direction = 1'b1                                                ;
        end

        else if (floor_req[0] && current_floor > 0) begin                     // else if request for 0th floor and the floor is        
            direction = 1'b0                                                ; // greater than 0 it move to 0th floor                                           
            next_state = move_down                                          ;
        end
        end

        move_up : begin
            direction = 1'b1                                                ; // when the lift is reaches to the 2nd and 1st floor
                                                                              // if the both the condition satisfied it will open
            if((floor_req[2] && current_floor==2) || (floor_req[1] && current_floor==1))
            begin
                next_state = open_door                                      ;
            end
            else begin
                next_state = move_up                                        ; // else it still move up
        end
        end

        move_down : begin
            direction =1'b0                                                 ; // when the lift is reaches to the 0nd and 1st floor
                                                                              // if the both the condition satisfied it will open

            if((floor_req[0] && current_floor==0) || (floor_req[1] && current_floor ==1))
            begin
                next_state = open_door                                      ;               
            end
            else begin
                next_state = move_down                                      ; // else it still move down
            end
        end
        
        open_door : begin                                       
            door_open = 1'b1                                                ; // if it is 1 it will open
            next_state = idle                                               ;
        end
        default : begin
            next_state = idle                                               ;
        end
    endcase
end
endmodule
