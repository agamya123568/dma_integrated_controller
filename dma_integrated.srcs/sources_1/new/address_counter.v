`timescale 1ns / 1ps



module address_counter(
    input  wire       clk,
    input  wire       rst,
    input  wire       en_a,
    input  wire       load_a,
    input  wire [7:0] data_in,
    input  wire       addr_inc,
    input  wire       commit,
    output reg  [7:0] addr_count,
    output reg        ACI
);

always @(posedge clk) begin
    if (rst) begin
        addr_count <= 8'd0;
        ACI        <= 1'b0;
    end else begin
        ACI <= 1'b0; // pulse by default

        if (load_a) begin
            addr_count <= data_in;
        end
        else if (en_a && commit) begin
            if (addr_inc)
                addr_count <= addr_count + 1'b1;
            else
                addr_count <= addr_count - 1'b1;

            ACI <= 1'b1; // one address update happened
        end
    end
end

endmodule
