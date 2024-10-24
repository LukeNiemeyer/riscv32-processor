`timescale 1us/100ns
module srai(in_data, shamt, out_data);

    input wire [31:0] in_data;    // 32-bit input data to be shifted
    input wire [4:0] shamt;       // 5-bit shift amount
    output wire [31:0] out_data;  // 32-bit output data

    // arithmetic right shift using the $signed function
    assign out_data = $signed(in_data) >>> shamt;

endmodule

