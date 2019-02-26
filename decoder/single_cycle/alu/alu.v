module ctrl_alu(bc,ct,opcode,reg_write,mem_read,mem_write,mem_reg,alu_src,sel_ex,branch,jump,pc_nxt,alu_op);
input[1:0] bc;
input ct;
input[4:0] opcode;
output reg reg_write,mem_read,mem_write,mem_reg,alu_src,sel_ex,branch,jump;
output reg[1:0] pc_nxt;
output reg [4:0]alu_op;
always@(*)
begin

    if(bc == 2'b00)
    begin
        if(ct == 1'b0)
        begin
            case(opcode)
                5'b00000:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00001 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end              
                
                5'b00001:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00001 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end

                5'b00010:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00010 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end

                5'b00011:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00011 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b00100:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00011 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b00101:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00100;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b00110:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00100 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b00111:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00101 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
   
                5'b01000:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b00110 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b01001:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01000 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
  
                5'b01010:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01001 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b01011:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01010 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
                
                5'b01100:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01011 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
   
                5'b01110:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01100 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b01111:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01101 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b10000:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01110 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
 
                5'b10001:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b01111 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
    
                5'b10010:begin
                    reg_write = 1'b1;mem_read =1'b0;mem_reg =1'b 0;alu_src =0;alu_op =5'b10000 ;sel_ex =1'b0;branch =1'b0 ;jump =1'b0;pc_nxt =2'b00;end
   
                   // default:1'b0;
                endcase
            end
        end
    end
    endmodule
    
                 
