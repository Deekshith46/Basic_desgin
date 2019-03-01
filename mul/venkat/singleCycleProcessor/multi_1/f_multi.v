module booth_encoder(
    input  signed [3:0] A,  // multiplicand
    input  signed [3:0] B,  // multiplier
    output signed [7:0] partial_products [3:0] // array of partial products
);
    integer i;
    reg signed [4:0] m; // extend A for shift operations
    reg signed [4:0] pp;

    always @(*) begin
        m = {A[3], A}; // sign-extend
        for(i = 0; i < 4; i = i + 1) begin
            case({B[i], (i==0 ? 1'b0 : B[i-1])})
                2'b01: pp = m;         // +A
                2'b10: pp = -m;        // -A
                default: pp = 5'd0;    // 0
            endcase
            partial_products[i] = pp <<< i; // shifted by position
        end
    end
endmodule
