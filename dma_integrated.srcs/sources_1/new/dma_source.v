`timescale 1ns / 1ps



module dma_source (
    input  wire       clk,
    input  wire       rst,
    input  wire       en_w,

    input  wire       wready,     // from FIFO
    output reg        wvalid,
    output reg [7:0]  wdata
);

always @(posedge clk) begin
    if (rst) begin
        wvalid <= 1'b0;
        wdata  <= 8'd0;
    end else if (!en_w) begin
        wvalid <= 1'b0;
    end else begin
        // If not currently holding valid data, generate one
        if (!wvalid) begin
            wvalid <= 1'b1;
        end
        // If FIFO accepted it, advance data
        else if (wvalid && wready) begin
            wdata  <= wdata + 1'b1;
            wvalid <= 1'b1; // immediately present next word
        end
    end
end

endmodule

