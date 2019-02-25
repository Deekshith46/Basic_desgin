module decoder(instruction,bc_o,ct_o,opcode_o,rs1_addr,rs2_addr,rd_addr,immediate,jump_imm,system_op)   ;
input      [31:0]   instruction                                                                         ; 
output reg [1:0]    bc_o                                                                                ; 
output reg          ct_o                                                                                ; 
output reg [4:0]    opcode_o                                                                            ; 
output reg [4:0]    rd_addr                                                                             ;
output reg [4:0]    rs1_addr                                                                            ;
output reg [4:0]    rs2_addr                                                                            ;
output reg [13:0]   immediate                                                                           ;
output reg [18:0]   jump_imm                                                                            ;
output reg [23:0]   system_op                                                                           ;

reg[8:0] resever                                                                                        ;

always@(*)
    begin
        
        bc_o         =  2'b00                                                                           ;
        ct_o         =  1'b0                                                                            ;
        opcode_o     =  5'b00000                                                                        ;
        resever      =  9'b0_0000_0000                                                                  ;
        immediate    =  14'b0000_0000_0000_00                                                           ;
        rs1_addr     =  5'b00000                                                                        ;
        rs2_addr     =  5'b00000                                                                        ;
        rd_addr      =  5'b00000                                                                        ;
        jump_imm     =  18'b0000_0000_0000_0000_00                                                      ;
        system_op    =  24'b0000_0000_0000_0000_0000                                                    ;
        
//////////////////////////////////////////////////////////R_TYPE/////////////////////////////////////////////////////////////////
       case({instruction[31:30],instruction[29]})

            3'b000 : begin  bc_o        = instruction[31:30]                                            ;
                            ct_o        = instruction[29]                                               ;
                            resever     = instruction[8:0]                                              ;                            
                            rs1_addr    = instruction[18:14]                                            ;
                            rs2_addr    = instruction[13:9]                                             ;
                            rd_addr     = instruction[23:19]                                            ;
                            opcode_o    = instruction[28:24]                                            ;
                      end                                                                                 
                        
//////////////////////////////////////////////////////////////I_TYPE///////////////////////////////////////////////////////////////
             3'b001 : begin
                             bc_o       = instruction[31:30]                                            ;
                             ct_o       = instruction[29]                                               ;
                             immediate  = instruction[13:0]                                             ;                      
                             rs1_addr   = instruction[18:14]                                            ;
                             rd_addr    = instruction[23:19]                                            ;
                             opcode_o   = instruction[28:24]                                            ;
                       end
                                
/////////////////////////////////////////////////////LOAD_TYPE///////////////////////////////////////////////////////////////////
             3'b010 : begin
                              bc_o      = instruction[31:30]                                            ;
                              ct_o      = instruction[29]                                               ;
                              immediate = instruction[13:0]                                             ;
                              rs1_addr  = instruction[18:14]                                            ;
                              rd_addr   = instruction[23:19]                                            ;
                              opcode_o  = instruction[28:24]                                            ;                                                
                       end

////////////////////////////////////////////////STORE_TYPE///////////////////////////////////////////////////////////////////////
            3'b011 :begin
                             bc_o       = instruction[31:30]                                            ;
                             ct_o       = instruction[29]                                               ;
                             immediate  = instruction[13:0]                                             ;
                             rs1_addr   = instruction[18:14]                                            ;
                             rs2_addr   = instruction[23:19]                                            ;
                             opcode_o   = instruction[28:24]                                            ;  
                    end
////////////////////////////////////////////BRANCH_TYPE//////////////////////////////////////////////////////////////////////////
            3'b100 : begin
                            bc_o        = instruction[31:30]                                            ;
                            ct_o        = instruction[29]                                               ;
                            immediate   = instruction[13:0]                                             ;
                            rs1_addr    = instruction[18:14]                                            ;
                            rs2_addr    = instruction[23:19]                                            ;
                            opcode_o    = instruction[28:24]                                            ;  
                     end
///////////////////////////////////////////JUMP_TYPE/////////////////////////////////////////////////////////////////////////////
            3'b101 : begin
                            bc_o        = instruction[31:30]                                            ;
                            ct_o        = instruction[29]                                               ;
                            jump_imm    = instruction[18:0]                                             ;                          
                            rd_addr     = instruction[23:19]                                            ;
                            opcode_o    = instruction[28:24]                                            ;  
                     end
////////////////////////////////////////SYSTEM_OPERATION/////////////////////////////////////////////////////////////////////////
            3'b110 : begin
                           bc_o         = instruction[31:30]                                            ;
                           ct_o         = instruction[29]                                               ;
                           system_op    = instruction[18:0]                                             ;                         
                           opcode_o     = instruction[28:24]                                            ;    
                     end
       endcase
   end

endmodule

