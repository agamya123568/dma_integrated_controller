`timescale 1ns / 1ps


module done_logic(
    input  wire clk,
    input  wire rst,
    input  wire en_w,
    input  wire WCI,
    input wire commit,
    output reg  done
);

always @(posedge clk) begin
    if (rst)
        done <= 1'b0;
    else
        // DONE is a pulse when last word completes
        done <= en_w && commit && WCI; //look

end

endmodule
