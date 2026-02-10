`timescale 1ns / 1ps

module word_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       load_w,
    input  wire       en_w,
    input  wire       commit,
    input  wire [7:0] data_in,
    output wire       WCI
);

reg [7:0] word_count;

always @(posedge clk) begin
    if (rst)
        word_count <= 8'd0;
    else if (load_w)
        word_count <= data_in;
    else if (en_w && commit && word_count != 0)
        word_count <= word_count - 1'b1;
end

assign WCI = (word_count == 0);

endmodule
