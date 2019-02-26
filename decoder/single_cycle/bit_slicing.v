module decoder(instruction,bc_o,ct_o,opcode_o,rs1_addr,rs2_addr,rd_addr,immediate,jump_imm,system_op);
input   [31:0]   instruction; // 32-bit instruction
output reg [1:0]    bc_o; // bit class
output reg          ct_o; //class type
output reg [4:0]   opcode_o; //opcode
output reg [4:0]   rd_addr;
output reg [4:0]   rs1_addr;
output reg [4:0]   rs2_addr;
output reg [13:0]  immediate;
output reg [18:0]  jump_imm;
output reg [23:0]  system_op;

reg[8:0] resever ;
reg [1:0] bc;
reg ct;
reg [4:0] opcode;


always@(*)
    begin
        
        bc = instruction[31:30];
        ct = instruction[29];
        opcode = instruction[28:24];
//////////////////////////////////////////////////////////R_TYPE/////////////////////////////////////////////////////////////////
        case({bc,ct})
            3'b000 : begin  bc_o = instruction[31:30];
                            ct_o = instruction[29];
                            resever = instruction[8:0];
                            
                            case(opcode)
                                5'b00000:begin //ADD
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                           end
                                5'b00001:begin//ADDU
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                5'b00010:begin//SUB
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b00011:begin//MUL
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b00100:begin//SMUL
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b00101:begin//DIV
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b00110:begin//IDIV
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b00111:begin//AND
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01000:begin//OR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01001:begin//XOR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01010:begin//NAND
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end

                                 5'b01011:begin//NOR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01100:begin//XNOR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01101:begin//SLL
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01110:begin//SRL
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b01111:begin//SAR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b10000:begin//ROR
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b10001:begin//ROL
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                                 5'b10010:begin//NOT
                                            rs1_addr = instruction[18:14];
                                            rs2_addr = instruction[13:9];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end                                       
                            endcase
                        end
//////////////////////////////////////////////////////////////I_TYPE///////////////////////////////////////////////////////////////
                  3'b001 : begin
                                bc_o = instruction[31:30];
                                ct_o = instruction[29];
                                immediate = instruction[13:0];
                      case(opcode)
                          5'b00000:begin //ADDI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                           end
                         5'b00001:begin//ADDUI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00010:begin//SUBI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00011:begin//MULI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00100:begin//SMUL
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00101:begin//DIVI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00110:begin//IDIV
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00111:begin//ANDI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01000:begin//ORI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01001:begin//XORI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01010:begin//NANDI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end

                         5'b01011:begin//NORI
                                            rs1_addr = instruction[18:14];                                           
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01100:begin//XNORI
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01101:begin//SLLI
                                            rs1_addr = instruction[18:14];                                           
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01110:begin//SRLI
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01111:begin//SARI
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10000:begin//RORI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10001:begin//ROLI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10010:begin//NOTI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end         
                        endcase                   
                end
 /////////////////////////////////////////////////////LOAD_TYPE///////////////////////////////////////////////////////////////////
              3'b010 : begin
                                bc_o = instruction[31:30];
                                ct_o = instruction[29];
                                immediate = instruction[13:0];
                      case(opcode)
                          5'b00000:begin //LW
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                           end
                         5'b00001:begin//LH
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00010:begin//LHU
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00011:begin//LB
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00100:begin//LBU
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00101:begin//LWP
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00110:begin//LHP
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b00111:begin//LHUP
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01000:begin//LBP
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01001:begin//LBUP
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01010:begin//LI
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end

                         5'b01011:begin//LIU
                                            rs1_addr = instruction[18:14];                                           
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01100:begin//LWPO
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01101:begin//LHPO
                                            rs1_addr = instruction[18:14];                                           
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01110:begin//LHUPO
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b01111:begin//LBPO
                                            rs1_addr = instruction[18:14];                                            
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10000:begin//LBUPO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10001:begin//LWD
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10010:begin//LHD
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end   
                         5'b10011:begin//LHUB
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end  
                         5'b10100:begin//LBD
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end 
                         5'b10101:begin//LBUD
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                         5'b10110:begin//LWRO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end  
                         5'b10111:begin//LHRO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end 
                         5'b11000:begin//LHURO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end
                        5'b11001:begin//LBRO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end  
                        5'b11010:begin//LBURO
                                            rs1_addr = instruction[18:14];
                                            rd_addr  = instruction[23:19];
                                            opcode_o = instruction[28:24];
                                         end                   
                        endcase                   
                end

////////////////////////////////////////////////STORE_TYPE///////////////////////////////////////////////////////////////////////


            endcase
        end

endmodule

