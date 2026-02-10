`timescale 1ns / 1ps


module fifo_2entry (
    input  wire       clk,
    input  wire       rst,

    input  wire [7:0] wdata,
    input  wire       wvalid,
    output wire       wready,

    output wire [7:0] rdata,
    output wire       rvalid,
    input  wire       rready
);

    reg [7:0] mem [0:1];
    reg       wptr, rptr;
    reg [1:0] count;

    assign wready = (count < 2);
    assign rvalid = (count > 0);

    // Mask data when FIFO empty (for waveform sanity)
    assign rdata = rvalid ? mem[rptr] : 8'bx;

    always @(posedge clk) begin
        if (rst) begin
            wptr  <= 0;
            rptr  <= 0;
            count <= 0;
        end else begin
            case ({wvalid && wready, rready && rvalid})
                2'b10: begin // write only
                    mem[wptr] <= wdata;
                    wptr <= ~wptr;
                    count <= count + 1;
                end
                2'b01: begin // read only
                    rptr <= ~rptr;
                    count <= count - 1;
                end
                2'b11: begin // simultaneous read & write
                    mem[wptr] <= wdata;
                    wptr <= ~wptr;
                    rptr <= ~rptr;
                    // count unchanged
                end
            endcase
        end
    end

endmodule


