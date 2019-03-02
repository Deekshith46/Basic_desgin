module dpa1#(
              parameter WIDTH = 32,
              parameter OP_LEN =5
)
(
 input [WIDTH - 1 :0 ] a,
 input [WIDTH - 1 :0 ] b,
 input cin,
 input [OP_LEN -1 :0 ] alu_op,

 output reg [WIDTH -1 :0 ] final_sum,
 output reg cout ,
 output reg negative_flag,
 output reg overflow_flag,
 output reg zero_flag);

 wire [WIDTH -1 :0 ] p ,g ;
 wire [WIDTH -1 :0 ] sum0;
 wire [WIDTH -1 :0 ] sum1;

//carry_propogation
assign p = a ^ b;
//carry_generation
assign g = a & b;
//sum0////
assign sum0 = p;
///sum1///
assign sum1 = ~p;
/////////////////////////carry_generation/////////////////

reg [WIDTH -1 :0 ] c;
integer i ;ac
reg [WIDTH -1 :0 ] sum;
reg [32:0] sign_extend;

always@(*) 
    begin 
    c[0] = cin;
    //carry//
    for(i=0; i < WIDTH ;  i = i +1)
    begin
        c[i+1] = g[i] | (p[i] & c[i]);
     end  
    for( i=0 ; i< WIDTH ; i = i+1)
    begin
        sum[i] = c[i] ? sum1[i] : sum0[i];
    end
    
    sign_extend = {sum[WIDTH-1],sum}; 

   if(alu_op == 5'b00010)
    begin
        final_sum = sign_extend;
        cout = sign_extend[WIDTH-1];
        zero_flag = (final_sum == {WIDTH{1'b0}});
        negative_flag =final_sum[WIDTH-1];
        overflow_flag = c[WIDTH] ^ c[WIDTH-1];        
    end
   else if(alu_op == 5'b00001 && sign_extend[WIDTH])
    begin
         final_sum = ~sign_extend + 1'b1;
         cout = final_sum[31];
    end
    end 
endmodule
