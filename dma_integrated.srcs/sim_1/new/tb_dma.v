
`timescale 1ns / 1ps

module tb_dma_top;

    reg clk;
    reg rst;

    reg [2:0] instr;
    reg [7:0] data_in;

    wire done;


    dma_top dut (
        .clk     (clk),
        .rst     (rst),
        .instr   (instr),
        .data_in (data_in),
        .done    (done)
    );

   
    always #5 clk = ~clk;

   
    initial begin
        clk = 0;
        rst = 1;
        instr = 0;
        data_in = 0;

        #20;
        rst = 0;

        /* -------------------------
           Load CONTROL register
           instr = 000
        ------------------------- */
        @(posedge clk);
        instr   <= 3'b000;
        data_in<= 8'b0000_011;   // example control bits
        @(posedge clk);
        instr   <= 3'b000;

        /* -------------------------
           Load ADDRESS (optional)
           instr = 101
        ------------------------- */
        @(posedge clk);
        instr   <= 3'b101;
        data_in<= 8'h10;
        @(posedge clk);
        instr   <= 3'b000;

        /* -------------------------
           Load WORD COUNT = 5
           instr = 110
        ------------------------- */
        @(posedge clk);
        instr   <= 3'b110;
        data_in<= 8'd5;
        @(posedge clk);
        instr   <= 3'b000;

        /* -------------------------
           START DMA
           instr = 111
        ------------------------- */
        @(posedge clk);
        instr <= 3'b111;
        @(posedge clk);
        instr <= 3'b000;

        /* -------------------------
           Wait for DONE
        ------------------------- */
        wait(done == 1'b1);
        $display("DMA DONE at time %0t", $time);

        #20;
        $finish;
    end

endmodule

