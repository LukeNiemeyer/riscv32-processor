`timescale 1us/100ns

// Define macros for instruction types based on opcode
`define ITYPE_OPCODE 7'b0010011   // I-type (ADDI, SLLI, etc.)
`define LW_OPCODE    7'b0000011   // I-type (loads like LW)
`define JALR_OPCODE  7'b1100111   // I-type (JALR)
`define STYPE_OPCODE 7'b0100011   // S-type (stores like SW)
`define BTYPE_OPCODE 7'b1100011   // B-type (branches like BEQ)
`define UTYPE_OPCODE 7'b0010111   // U-type (AUIPC)
`define LUI_OPCODE   7'b0110111   // U-type (LUI)
`define JTYPE_OPCODE 7'b1101111   // J-type (JAL)

module immediate_decoder(instruction, immediate);

    input wire [31:0] instruction;  // 32-bit RISC-V instruction
    output reg [31:0] immediate;    // 32-bit sign-extended immediate value

    // Extract instruction type based on opcode (7 least-significant bits)
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            `ITYPE_OPCODE: begin // I-type (ADDI, SLLI, etc.)
                immediate = {{20{instruction[31]}}, instruction[31:20]};  // Sign-extend 12-bit immediate
            end
            `LW_OPCODE: begin // I-type (loads like LW)
                immediate = {{20{instruction[31]}}, instruction[31:20]};  // Sign-extend 12-bit immediate
            end
            `JALR_OPCODE: begin // I-type (JALR)
                immediate = {{20{instruction[31]}}, instruction[31:20]};  // Sign-extend 12-bit immediate
            end
            `STYPE_OPCODE: begin // S-type (stores like SW)
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};  // Sign-extend
            end
            `BTYPE_OPCODE: begin // B-type (branches like BEQ)
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};  // Sign-extend and shift left by 1
            end
            `UTYPE_OPCODE, `LUI_OPCODE: begin // U-type (AUIPC, LUI)
                immediate = {instruction[31:12], {12{instruction[31]}}};  // Upper 20 bits with 12 zero bits
            end
            `JTYPE_OPCODE: begin // J-type (JAL)
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};  // Sign-extend and shift left by 1
            end
            default: begin
                immediate = 32'b0;  // Default immediate value (NOP or unhandled instruction)
            end
        endcase
    end
endmodule

