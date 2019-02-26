/*
    31     30  29  28      24 23      19 18     14 13      9 8       0
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RD_addrr |RS1_addrr|RS2_addrr| RESERVED|  ALU TYPE
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RD_addrr |RS1_addrr| [13:0] immediate  |  ALU-I TYPE
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RD_addrr |RS1_addrr| [13:0] immediate  |  LOAD
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RS2_addrr|RS1_addrr| [13:0] immediate  |  STORE 
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RS2_addrr|RS1_addrr| [13:0] immediate  |  BRANCH
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE | RD_addrr |    [18:0] immediate         |  JUMP
    ------------------------------------------------------------------
    |   BC  |  CT  | OPCODE |      [23:0] SYSTEM_OP_IMM              |  SYSTEM_OPERATION 
    ------------------------------------------------------------------
*/



module decoder(instruction,bc_o,ct_o,opcode_o,rd_addr,rs1_addr,rs2_addr,immediate,jump_imm,system_op);



     parameter INST_W = 32                                                                           ;
     parameter BC_W   = 2                                                                            ;                                         
     parameter OPC_W  = 5                                                                            ;
     parameter RD_W   = 5                                                                            ;
     parameter RS_W   = 5                                                                            ;
     parameter IMM_W  = 14                                                                           ;
     parameter JIMM_W = 18                                                                           ;
     parameter SYS_W  = 24                                                                           ;
     parameter RSV_W  = 9                                                                            ;


    parameter BC_HIGH           = 31                                                                 ;
    parameter BC_LOW            = 30                                                                 ;
    parameter CT                = 29                                                                 ;
    parameter OPCODE_HIGH       = 28                                                                 ;
    parameter OPCODE_LOW        = 24                                                                 ;
    parameter RD_AD_HIGH        = 23                                                                 ;
    parameter RD_AD_LOW         = 19                                                                 ;
    parameter RS1_AD_HIGH       = 18                                                                 ;
    parameter RS1_AD_LOW        = 14                                                                 ;
    parameter RS2_AD_HIGH       = 13                                                                 ;
    parameter RS2_AD_LOW        = 9                                                                  ;
    parameter RESERVED_HIGH     = 8                                                                  ;
    parameter RESERVED_LOW      = 0                                                                  ;
    parameter IMM_HIGH          = 13                                                                 ;
    parameter IMM_LOW           = 0                                                                  ;
    parameter JUMP_IM_HIGH      = 18                                                                 ;
    parameter JUMP_IM_LOW       = 0                                                                  ;
    parameter SYSTEM_IM_HIGH    = 23                                                                 ;
    parameter SYSTRM_IM_LOW     = 0                                                                  ;
    

  
    input         [INST_W-1  :0]   instruction                                                       ;                                                                     
    output reg    [BC_W  -1  :0]   bc_o                                                              ;                                                                          
    output reg                     ct_o                                                              ;                                                                         
    output reg    [OPC_W -1  :0]   opcode_o                                                          ;                                                                         
    output reg    [RD_W  -1  :0]   rd_addr                                                           ;                                                                         
    output reg    [RS_W  -1  :0]   rs1_addr                                                          ;                                                                        
    output reg    [RS_W  -1  :0]   rs2_addr                                                          ;                                                                        
    output reg    [IMM_W -1  :0]   immediate                                                         ;                                                                         
    output reg    [JIMM_W-1  :0]   jump_imm                                                          ;                                                                         
    output reg    [SYS_W -1  :0]   system_op                                                         ;
                                                                                                                                                                       



    

    reg [RSV_W - 1:0] resever                                                                            ;

always@(*)
    begin
        
        bc_o         =  {BC_W{1'b0}}                                                                 ;
        ct_o         =  1'b0                                                                         ;
        opcode_o     =  {OPC_W{1'b0}}                                                                ;
        resever      =  {RSV_W{1'b0}}                                                                ;
        immediate    =  {IMM_W{1'b0}}                                                                ;
        rs1_addr     =  {RS_W {1'b0}}                                                                ;
        rs2_addr     =  {RS_W {1'b0}}                                                                ;
        rd_addr      =  {RD_W {1'b0}}                                                                ;
        jump_imm     =  {JIMM_W {1'b0}}                                                              ;
        system_op    =  {SYS_W {1'b0}}                                                               ;
        
//////////////////////////////////////////////////////////R_TYPE/////////////////////////////////////////////////////////////////
       case({instruction[BC_HIGH : BC_LOW],instruction[CT]})

            3'b000 : begin  bc_o        = instruction[BC_HIGH :BC_LOW]                               ;
                            ct_o        = instruction[CT]                                            ;
                            resever     = instruction[RESERVED_HIGH:RESERVED_LOW]                    ;                            
                            rs1_addr    = instruction[RS1_AD_HIGH:RS1_AD_LOW]                        ;
                            rs2_addr    = instruction[RS2_AD_HIGH :RS2_AD_LOW]                       ;
                            rd_addr     = instruction[RD_AD_HIGH:RD_AD_LOW]                          ;
                            opcode_o    = instruction[OPCODE_HIGH:OPCODE_LOW ]                       ;
                      end                                                                                 
                        
//////////////////////////////////////////////////////////////I_TYPE///////////////////////////////////////////////////////////////
             3'b001 : begin
                             bc_o       = instruction[BC_HIGH :BC_LOW]                               ;
                             ct_o       = instruction[CT]                                            ;
                             immediate  = instruction[IMM_HIGH:IMM_LOW]                              ;                      
                             rs1_addr   = instruction[RS1_AD_HIGH:RS1_AD_LOW]                        ;
                             rd_addr    = instruction[RD_AD_HIGH:RD_AD_LOW]                          ;
                             opcode_o   = instruction[OPCODE_HIGH :OPCODE_LOW ]                      ;
                       end
                                
/////////////////////////////////////////////////////LOAD_TYPE///////////////////////////////////////////////////////////////////
             3'b010 : begin
                              bc_o      = instruction[BC_HIGH :BC_LOW]                               ;
                              ct_o      = instruction[CT]                                            ;
                              immediate = instruction[IMM_HIGH:IMM_LOW]                              ;
                              rs1_addr  = instruction[RS1_AD_HIGH:RS1_AD_LOW]                        ;
                              rd_addr   = instruction[RD_AD_HIGH:RD_AD_LOW]                          ;
                              opcode_o  = instruction[OPCODE_HIGH:OPCODE_LOW]                        ;                                                
                       end

////////////////////////////////////////////////STORE_TYPE///////////////////////////////////////////////////////////////////////
            3'b011 : begin
                             bc_o       = instruction[BC_HIGH :BC_LOW]                               ;
                             ct_o       = instruction[CT]                                            ;
                             immediate  = instruction[IMM_HIGH:IMM_LOW]                              ;
                             rs1_addr   = instruction[RS1_AD_HIGH:RS1_AD_LOW]                        ;
                             rs2_addr   = instruction[RD_AD_HIGH :RD_AD_LOW ]                        ;
                             opcode_o   = instruction[OPCODE_HIGH:OPCODE_LOW]                        ;  
                     end
////////////////////////////////////////////BRANCH_TYPE//////////////////////////////////////////////////////////////////////////
            3'b100 : begin
                            bc_o        = instruction[BC_HIGH :BC_LOW]                               ;
                            ct_o        = instruction[CT]                                            ;
                            immediate   = instruction[IMM_HIGH:IMM_LOW]                              ;
                            rs1_addr    = instruction[RS1_AD_HIGH:RS1_AD_LOW]                        ;
                            rs2_addr    = instruction[RD_AD_HIGH :RD_AD_LOW ]                        ;
                            opcode_o    = instruction[OPCODE_HIGH:OPCODE_LOW]                        ;  
                     end
///////////////////////////////////////////JUMP_TYPE/////////////////////////////////////////////////////////////////////////////
            3'b101 : begin
                            bc_o        = instruction[BC_HIGH :BC_LOW]                               ;
                            ct_o        = instruction[CT]                                            ;
                            jump_imm    = instruction[JUMP_IM_HIGH:JUMP_IM_LOW]                      ;                          
                            rd_addr     = instruction[RD_AD_HIGH:RD_AD_LOW]                          ;
                            opcode_o    = instruction[OPCODE_HIGH:OPCODE_LOW]                        ;  
                     end
////////////////////////////////////////SYSTEM_OPERATION/////////////////////////////////////////////////////////////////////////
            3'b110 : begin
                           bc_o         = instruction[BC_HIGH :BC_LOW]                               ;
                           ct_o         = instruction[CT]                                            ;
                           system_op    = instruction[SYSTEM_IM_HIGH:SYSTRM_IM_LOW]                  ;                         
                           opcode_o     = instruction[OPCODE_HIGH:OPCODE_LOW]                        ;    
                     end
       endcase
   end

endmodule

