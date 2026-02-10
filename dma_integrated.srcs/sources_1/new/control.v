`timescale 1ns / 1ps


module control(
    input  wire       clk,
    input  wire       rst,
    input  wire       load_ctrl,
    input  wire [7:0] data_in,
    output wire [1:0] word_inc,
    output wire       addr_inc
);

reg [2:0] control_reg;

always @(posedge clk) begin
    if (rst)
        control_reg <= 3'b000;
    else if (load_ctrl)
        control_reg <= data_in[2:0];
end

assign word_inc = control_reg[1:0];
assign addr_inc = control_reg[2];
endmodule
