
module tb                                       ;
reg clk                                         ;
reg rst                                         ;
reg[2:0] floor_req                              ;
reg[1:0] current_floor                          ;
wire direction                                  ;
wire door_open                                  ;

elevator dut1(.clk(clk),
              .rst(rst),
              .floor_req(floor_req), 
              .current_floor(current_floor), 
              .direction(direction) , 
              .door_open(door_open))            ;
always begin
    clk =0                                      ;
    forever #10 clk = ~clk                      ;
end

initial begin
    $shm_open("wave.shm")                       ;
    $shm_probe("ACTMF")                         ;
end

initial begin
    rst =0                                      ;
    floor_req = 3'b000                          ;
    current_floor = 2'b00                       ;
///testcase1 reset and idle state
    #20 rst = 1                                 ;

////testcase2 request to moveup to the floor 2
#20 floor_req = 3'b100                          ; // 2nd floor
#40 current_floor = 2'b10                       ;// reacch floor 2
#20 floor_req = 3'b000                          ; //requeat clear

/// testcase3 request o move down to floor 0
#20 floor_req = 3'b001                          ; // 0th floor
    current_floor = 2'b10                       ;// it start at floor1 
#40 current_floor = 2'b00                       ;// reach to 0th
#20 floor_req = 3'b000                          ;

/// testcase 5 : no req
#20 floor_req = 3'b000                          ; // 2nd floor
#40                                             ;
$finish()                                       ; 
end
endmodule
