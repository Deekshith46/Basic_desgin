module booth_radix4_multiplier (
    input  signed [3:0] A,   // multiplicand
    input  signed [3:0] B,   // multiplier
    output signed [7:0] P    // final product
);
    reg signed [7:0] pp0, pp1;  
    reg signed [7:0] result;
    reg [4:0] B_ext;          // <---- Moved here, not inside always

    always @(*) begin
        B_ext = {B, 1'b0};  

        // ---- Group 0 ----
        case (B_ext[2:0])
            3'b000, 3'b111: pp0 = 8'd0;
            3'b001, 3'b010: pp0 = {{4{A[3]}}, A};
            3'b011:         pp0 = {{3{A[3]}}, A, 1'b0};
            3'b100:         pp0 = -{{3{A[3]}}, A, 1'b0};
            3'b101, 3'b110: pp0 = -{{4{A[3]}}, A};
        endcase

        // ---- Group 1 ----
        case (B_ext[4:2])
            3'b000, 3'b111: pp1 = 8'd0;
            3'b001, 3'b010: pp1 = {{4{A[3]}}, A} << 2;
            3'b011:         pp1 = ({{3{A[3]}}, A, 1'b0}) << 2;
            3'b100:         pp1 = -( {{3{A[3]}}, A, 1'b0} << 2);
            3'b101, 3'b110: pp1 = -( {{4{A[3]}}, A} << 2);
        endcase

        result = pp0 + pp1;
    end

    assign P = result;
endmodule

