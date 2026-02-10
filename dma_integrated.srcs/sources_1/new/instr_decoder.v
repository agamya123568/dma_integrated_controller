`timescale 1ns / 1ps


module instr_decoder(
    input  wire clk,
    input  wire rst,
    input  wire [2:0] instr,
    output reg  load_ctrl,
    output reg  load_addr,
    output reg  load_word,
    output reg start
);

always @(posedge clk) begin
    if (rst) begin
        load_ctrl <= 0;
        load_addr <= 0;
        load_word <= 0;
        start     <= 0;
    end else begin
        load_ctrl <= 0;
        load_addr <= 0;
        load_word <= 0;
        start     <= 0;

        case (instr)
            3'b000: load_ctrl <= 1; // load control register
            3'b101: load_addr <= 1; // load address register
            3'b110: load_word <= 1; //load word 
            3'b111: start     <= 1;   // START pulse
        endcase
    end
end
endmodule
