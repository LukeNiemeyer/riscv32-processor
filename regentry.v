`timescale 1us/100ns
module regentry(D, clk, rst, write_enable, Q);

    input wire [31:0] D;         // 32-bit data input
    input wire clk;              // Clock
    input wire rst;              // Reset
    input wire write_enable;     // Write enable signal
    output wire [31:0] Q;        // 32-bit data output

    dflop32 reg_dff (
        .q(Q), 
        .d(write_enable ? D : Q),  // If write_enable is high, write data
        .clk(clk), 
        .rst(rst)
    );

endmodule
