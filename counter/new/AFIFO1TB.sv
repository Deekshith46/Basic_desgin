`timescale 1ns / 1ps

module tb_async_fifo30;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    // Signals
    reg wr_clk;
    reg rd_clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;
    real rand_delay;
    real duty_cycle;
    real ton;
    real toff;
    integer seed;
    real rand_delay1;
    real duty_cycle1;
    real ton1;
    real toff1;
    wire overflow;
    wire underflow;
    integer scenario;
    reg [4:0] count;

    logic [DATA_WIDTH-1:0] tb_dataout;
    logic tb_full;
    logic tb_empty;
    logic tb_overflow;
    logic tb_underflow;
    logic [4:0] wr_ptrtb;
    logic [4:0] rd_ptrtb;
    reg [DATA_WIDTH-1:0] fifo_memtb [0:DEPTH-1];
   
    // Instantiate the FIFO
    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) fifo (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .overflow(overflow),
        .underflow(underflow)
    );

    // Clock initialization
    initial begin
        wr_clk = 0;
        rd_clk = 0;
    end

    // Randomized clock generation
    initial begin
        seed = $urandom_range(0, 100);

        rand_delay = 100 + ($urandom(seed) % 101);
        duty_cycle = 40 + ($urandom(seed) % 21);
        rand_delay1 = 80 + ($urandom(seed) % 161);
        duty_cycle1 = 40 + ($urandom(seed) % 21);

        ton = (duty_cycle / 100) * (1 / rand_delay);
        toff = (1 / rand_delay) - ton;

        ton1 = (duty_cycle1 / 100) * (1 / rand_delay1);
        toff1 = (1 / rand_delay1) - ton1;
    end

    initial begin
        forever begin
            #(ton) wr_clk = 1;
            #(toff) wr_clk = 0;

            #(ton1) rd_clk = 1;
            #(toff1) rd_clk = 0;
        end
    end

    // Open waveform dump
    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
    end

    // Test sequence based on scenario from command-line argument
    initial begin
        if (!$value$plusargs("scenario=%d", scenario)) begin
            $display("No scenario provided! Use +scenario=<1-4>");
            $finish;
        end

        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        #1;
        rst = 0;

        if (scenario == 1) begin
            $display("Scenario 1: Write to Full, then Read to Empty");

            repeat (16) begin
                @(posedge wr_clk);
                din = din + 1;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 0;
            if (full)
                $display("FIFO is full after writing 16 elements.");

            repeat (16) begin
                @(posedge rd_clk);
                rd_en = 1;
                @(posedge rd_clk);
                rd_en = 0;
                if (!empty)
                    $display("Read data: %d", dout);
                else
                    $display("FIFO is empty during read.");
            end

            @(posedge rd_clk);
            rd_en = 0;
            if (empty)
                $display("FIFO is empty after reading all elements.");
        end

        else if (scenario == 2) begin
            $display("Scenario 2: Overflow and Underflow");

            repeat (16) begin
                @(posedge wr_clk);
                din = din + 1;
                wr_en = 1;
            end
            @(posedge wr_clk);
            wr_en = 0;

            @(posedge wr_clk);
            if (full) begin
                wr_en = 1;
                din = 18;
                @(posedge wr_clk);
                wr_en = 0;
                if (overflow)
                    $display("Overflow detected.");
            end

            repeat (16) begin
                @(posedge rd_clk);
                rd_en = 1;
                @(posedge rd_clk);
                rd_en = 0;
                if (!empty)
                    $display("Read data: %d", dout);
                else
                    $display("FIFO is empty during read.");
            end

            @(posedge rd_clk);
            if (empty) begin
                rd_en = 1;
                @(posedge rd_clk);
                rd_en = 0;
                if (underflow)
                    $display("Underflow detected.");
            end
        end
#30;

        $finish;
    end

    // Scoreboard logic
    always @(posedge wr_clk) begin
        if (rst) begin
            count = 0;
            wr_ptrtb = 0;
            tb_full = 0;
        end  if  (!rst&&wr_en && !tb_full) begin
            fifo_memtb[wr_ptrtb] = din;
            wr_ptrtb = (wr_ptrtb + 1) % DEPTH;
            count = count + 1;
        end
        tb_full = (count == DEPTH);
    end

     always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
           tb_overflow = 0;
        end  if (wr_en && tb_full) begin      // Overflow when writing to full FIFO
            tb_overflow = 1;
        end else begin
            tb_overflow = 0;                     // Clear overflow when not writing to full
        end
    end
  
         //read operation//

    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptrtb = 0;
            tb_dataout = 0;
            tb_empty = 1;
            count <= 0;
        end else if (rd_en && !tb_empty) begin
            tb_dataout <= fifo_memtb[rd_ptrtb];
            rd_ptrtb <= (rd_ptrtb + 1) % DEPTH;
            count <= count - 1;
        end
            tb_empty <= (count == 0 || (rd_en && count == 1)) ? 1 : 0;
           end

//tb_uderflow//
  always @(posedge rd_clk) begin
        if (rd_en && tb_empty) begin
            tb_underflow <= 1; // Set underflow if trying to read when empty
        end else if (!rd_en) begin
            tb_underflow <= 0; // Reset underflow when not reading
        end
    end

    // Data comparison
    always @(posedge wr_clk or posedge rd_clk) begin
        if (dout === tb_dataout)
            $display("%t, PASS: Data matched", $realtime);
        else
            $error("%t, FAIL: Data mismatch", $realtime);

        if (full === tb_full)
            $display("%t, PASS: Full flag matched", $realtime);
        else
            $error("%t, FAIL: Full flag mismatch", $realtime);

        if (empty === tb_empty)
            $display("%t, PASS: Empty flag matched", $realtime);
        else
            $error("%t, FAIL: Empty flag mismatch", $realtime);

        if (overflow === tb_overflow)
            $display("%t, PASS: Overflow flag matched", $realtime);
        else
            $error("%t, FAIL: Overflow flag mismatch", $realtime);

        if (underflow === tb_underflow)
            $display("%t, PASS: Underflow flag matched", $realtime);
        else
            $error("%t, FAIL: Underflow flag mismatch", $realtime);
    end

///coverage//
covergroup abc;
A: coverpoint din
{
 bins bin_0={0};
 bins bin_1={1};
 bins bin_2={2};
 bins bin_3={3};
 bins bin_4={4};
 bins bin_5={5};
 bins bin_6={6};
 bins bin_7={7};
 bins bin_8={8};
 bins bin_9={9};
 bins bin_10={10};
 bins bin_11={11};
 bins bin_12={12};
 bins bin_13={13};
 bins bin_14={14};
 bins bin_15={15};
}
B:coverpoint wr_clk
{
 bins bin_0={0};
 bins bin_1={1};
}
C:coverpoint rd_clk
{
 bins bin_0={0};
 bins bin_1={1};
}
D:coverpoint wr_en
{
 bins bin_0={0};
 bins bin_1={1};
}
E:coverpoint rd_en
{
 bins bin_0={0};
 bins bin_1={1};
}
F:coverpoint rst
{
 bins bin_0={0};
 bins bin_1={1};
}
endgroup:abc
abc abc_h;
initial begin
abc_h=new();
repeat(300)
begin
#5
abc_h.sample();
end
end

endmodule


