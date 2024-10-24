`timescale 1us/100ns
module srli(in_data, shamt, out_data);

    input wire [31:0] in_data;    // 32-bit input data to be shifted
    input wire [4:0] shamt;       // 5-bit shift amount
    output wire [31:0] out_data;  // 32-bit output data

    // logical right shift
    assign out_data = in_data >> shamt;

endmodule

