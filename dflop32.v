`timescale 1us/100ns
module dflop32(q, d, clk, rst);

    output reg [31:0] q;      // 32-bit output
    input wire [31:0] d;      // 32-bit input
    input wire clk;           // Clock signal
    input wire rst;           // Reset signal

    always @(posedge clk) begin
        if (rst)
            q <= 32'b0;       // Reset the output to 0
        else
            q <= d;           // Write the 32-bit data to the output
    end

endmodule

