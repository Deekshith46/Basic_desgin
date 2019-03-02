module dpa1#(
              parameter WIDTH = 32,
              //parameter OP_LEN =5,
              parameter SIGNED_W =33
)
(
 input [WIDTH - 1 :0 ] a,
 input [WIDTH - 1 :0 ] b,
 input cin,
 //input [OP_LEN -1 :0 ] alu_op,

 output  [WIDTH -1 :0 ] final_sum,
 output  cout ,
 output  negative_flag,
 output  overflow_flag,
 output  zero_flag);

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
integer i ;
reg [WIDTH -1 :0 ] sum;
wire [SIGNED_W -1 :0] sign_extend;

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
end
      assign sign_extend = {sum[WIDTH-1],sum}; 
      assign final_sum = sign_extend;
      assign cout = sign_extend[WIDTH-1];
      assign  zero_flag = (final_sum == {WIDTH{1'b0}});
      assign  negative_flag =final_sum[WIDTH-1];
      assign overflow_flag = c[0] ^ c[WIDTH-1];
     
endmodule
