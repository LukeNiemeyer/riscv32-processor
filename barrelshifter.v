`timescale 1us/100ns

`define SLLI 2'b00  // Shift Left Logical Immediate
`define SRLI 2'b01  // Shift Right Logical Immediate
`define SRAI 2'b10  // Shift Right Arithmetic Immediate

module barrelshifter(in_data, shamt, shift_type, out_data);

    input wire [31:0] in_data;
    input wire [4:0] shamt;
    input wire [1:0] shift_type;
    output reg [31:0] out_data;  // `reg` type for output driven by always block

    wire [31:0] slli_out, srli_out, srai_out;

    slli slli_inst (
        .in_data(in_data),
        .shamt(shamt),
        .out_data(slli_out)
    );

    srli srli_inst (
        .in_data(in_data),
        .shamt(shamt),
        .out_data(srli_out)
    );

    srai srai_inst (
        .in_data(in_data),
        .shamt(shamt),
        .out_data(srai_out)
    );

    always @(*) begin
        case (shift_type)
            `SLLI: out_data = slli_out;    // SLLI operation
            `SRLI: out_data = srli_out;    // SRLI operation
            `SRAI: out_data = srai_out;    // SRAI operation
            default: out_data = in_data;   // Default case, no shift
        endcase
    end

endmodule

