module cpu_top #(
                
                parameter integer WIDTH = 32,
                parameter integer INT_WIDTH = 8,

                input clk,
                input rst,
                input [INT_WIDTH - 1 : 0] int_in

                );

wire n_w,z_w,v_w,c_w;             

controller  counter_unit         (       
                                  .clk(clk),
                                  .rst(rst),
                                  .int_in(int_in),
                                  .mtvec(),
                                  .n(n_w),
                                  .z(z_w),
                                  .v(v_w),
                                  .c(c_w),
                                  .rs_val(),
                                  .regwrite(),
                                  .memread(),
                                  .memwrite(),
                                  .memtoreg(),
                                  .aluop(),
                                  .sel_pc(),
                                  .sel_rs2(),
                                  .sel_imm1(),
                                  .sel_imm2(),
                                  .sel_rs1(),
                                  .sel_ex(),
                                  .sel_imm(),
                                  .sel_hw(),
                                  .sel_w(),
                                  .ld_mem_reg(),
                                  .ld_mar(),
                                  .ld_mdr(),
                                  .alusrc(),
                                  .bc_out(),
                                  .ct_out(),
                                  .rs1_addr_out(),
                                  .rs2_addr_out(),
                                  .rd_addr_out(),
                                  .optoload(),
                                  .pc_out1(),
                                  .imm_out(),
                                  .sel_rd());

load_store_top_module load_store (
                                  .data_from_rs1(),
                                  .data_from_rs2(),
                                  .PC(),
                                  .immediate();
                                  .BC(),
                                  .OPCODE(),
                                  .from_alu_out(),
                                  .CT(),
                                  .sel_pc(),
                                  .sel_rs1(),
                                  .sel_rs2(),
                                  .sel_ex(),
                                  .sel_imm_1(),
                                  .sel_imm_2(),
                                  .sel_hw(),
                                  .sel_w(),
                                  .ld_mem_reg(),
                                  .ld_mar(),
                                  .ld_mdr());
 

alu_op alu_module                 (
                                  .in_1(),
                                  .in_2(),
                                  .aluop(),
                                  .alu_out(),
                                  .negative_flag(n_w),
                                  .overflow_flag(o_w),
                                  .zero_flag(z_w),
                                  .carry_flag(c_w));



RegisterFile Gpr
                                   (
                                   .reg_wr_en(),
                                   .write_reg(),
                                   .reg_rw_data(),
                                   .reg_rd1(),
                                   .reg_rd2(),
                                   .reg_rd_data1(),
                                   .reg_rd_data2()
                                   );
endmodule                        
