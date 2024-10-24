`timescale 1us/100ns

// Define macros for the instruction selectors (func7 + func3 combined)
`define ADD   10'b0000000000
`define SUB   10'b0100000000
`define XOR   10'b0000000100
`define OR    10'b0000000110
`define AND   10'b0000000111
`define SLLI  10'b0000000001
`define SRLI  10'b0000000101
`define SRAI  10'b0100000101
`define SLLISHIFT 2'b00
`define SRLISHIFT 2'b01
`define SRAISHIFT 2'b10

// Branch condition selectors
`define BEQ   3'b000  // Branch if equal
`define BNE   3'b001  // Branch if not equal
`define BLT   3'b100  // Branch if less than
`define BGE   3'b101  // Branch if greater or equal
`define BLTU  3'b110  // Branch if Less Than (unsigned)
`define BGEU  3'b111  // Branch if Greater or Equal (unsigned)

module alu(
    input wire [31:0] in0,          // First operand
    input wire [31:0] in1,          // Second operand
    input wire [9:0] selector,      // 10-bit selector (func7 + func3)
    output reg branch_taken,        // Branch taken signal
    output reg [31:0] out,          // Output of the ALU
    output reg c_out                // Carry out (not used yet)
);

    wire [31:0] barrel_out;
    reg [1:0] shift_type;
    reg [4:0] shamt;
    wire [2:0] func3 = selector [2:0];

    // Instantiate the barrel shifter module
    barrelshifter bs(
        .in_data(in0),
        .shamt(shamt),
        .shift_type(shift_type),
        .out_data(barrel_out)
    );

    // ALU operation logic using case statement
    always @(*) begin
        c_out = 0;                 // Default no carry-out
        shamt = in1[4:0];           // Extract shift amount
        out = 32'h00000000;         // Default result
	branch_taken = 0;
        
        case (selector)
            // Arithmetic Operations
            `ADD: out = in0 + in1;          // ADD
            `SUB: out = in0 - in1;          // SUBTRACT

            // Logical Operations
            `XOR: out = in0 ^ in1;          // XOR
            `OR:  out = in0 | in1;          // OR
            `AND: out = in0 & in1;          // AND

            // Shift Operations
            `SLLI: begin
                shift_type = `SLLISHIFT;         // Shift Left Logical Immediate
                out = barrel_out;
            end
            `SRLI: begin
                shift_type = `SRLISHIFT;         // Shift Right Logical Immediate
                out = barrel_out;
            end
            `SRAI: begin
                shift_type = `SRAISHIFT;         // Shift Right Arithmetic Immediate
                out = barrel_out;
            end

            default: out = 32'h00000000;    // Default case (NOP)
        endcase
    
        case (func3)
            `BEQ: branch_taken = (in0 == in1);      			// BEQ: Branch if Equal
            `BNE: branch_taken = (in0 != in1);      			// BNE: Branch if Not Equal
            `BLT: branch_taken = ($signed(in0) < $signed(in1));  	// BLT: Branch if Less Than (signed)
            `BGE: branch_taken = ($signed(in0) >= $signed(in1)); 	// BGE: Branch if Greater or Equal (signed)
            `BLTU: branch_taken = (in0 < in1);       			// BLTU: Branch if Less Than (unsigned)
            `BGEU: branch_taken = (in0 >= in1);      			// BGEU: Branch if Greater or Equal (unsigned)
            default: branch_taken = 0;                			// Default: No branch taken
        endcase
    end

endmodule