`timescale 1ns/1ps

module tb_compare;

    parameter WIDTH = 64; // keep small for easy viewing

    reg  [WIDTH-1:0] a, b;
    reg              cin;
    reg              signed_en;

    // Outputs from raw version
    wire [WIDTH-1 :0] final_sum;
    wire cout;
    wire negative_flag;
    wire overflow_flag;
    wire zero_flag;

       // Instantiate raw version
DPA1 #(.N(WIDTH)) dut (.a(a),
                       .b(b),
                       .cin(cin),
                       .signed_en(signed_en),
                       .final_sum(final_sum),
                       .cout(cout),
                       .negative_flag(negative_flag),
                       .overflow_flag(overflow_flag),
                       .zero_flag(zero_flag));
         initial begin
             $shm_open("wave.shm");
             $shm_probe("ACTMF");
         end
        initial begin
        
        $display("time |   a   |   b   | cin | signed | raw_out (u/s) | mag_out (u/s) | neg ovf z");
        $display("-------------------------------------------------------------------------------");

        // Case 1: 5 + 3
        a=8'd5; b=8'd3; cin=0; signed_en=0; #10;
        show_results;
        signed_en=1; #10;
        show_results;

        // Case 2: 5 - 7 (unsigned wrap vs signed negative)
        a=5; b=-7; cin=1; signed_en=1; #10;
        show_results;
        signed_en=1; #10;
        show_results;

        // Case 3: overflow in signed mode (127 + 1 = -128)
        a=8'd127; b=8'd1; cin=0; signed_en=0; #10;
        show_results;
        signed_en=1; #10;
        show_results;

        $finish;
    end

    task show_results;
        begin
            $display("%4t | %4d | %4d |  %b  |   %b    | %4d / %4d | %4d / %4d | %b %b %b",
                     $time, a, b, cin, signed_en,
                     $unsigned(final_sum), $signed(final_sum),
                     $unsigned(final_sum), $signed(final_sum),
                     negative_flag, overflow_flag, zero_flag);
        end
    endtask

endmodule

