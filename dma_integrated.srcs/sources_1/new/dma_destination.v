`timescale 1ns / 1ps


module dma_destination (
    input  wire       clk,
    input  wire       rst,
    input  wire       en_w,

    input  wire       dst_valid,
    input  wire [7:0] dst_data,
    output wire       dst_ready
);

assign dst_ready = en_w;  // ALWAYS READY when DMA active

endmodule
