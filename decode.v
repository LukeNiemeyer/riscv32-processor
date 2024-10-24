`timescale 1us/100ns
`define INST_ENCODING_JAL     32'bxxxxxxxxxxxxxxxxxxxxxxxxx1101111
`define INST_ENCODING_JALR    32'bxxxxxxxxxxxxxxxxx000xxxxx1100111
`define INST_ENCODING_BRANCH  32'bxxxxxxxxxxxxxxxxxxxxxxxxx1100011
`define INST_ENCODING_LW      32'bxxxxxxxxxxxxxxxxx010xxxxx0000011 // Load Word
`define INST_ENCODING_SW      32'bxxxxxxxxxxxxxxxxx010xxxxx0100011 // Store Word
`define INST_ENCODING_AUIPC   32'bxxxxxxxxxxxxxxxxxxxxxxxxx0010111 // AUIPC
`define INST_ENCODING_ALUI    32'bxxxxxxxxxxxxxxxxx???xxxxx0010011 // ALU Immediate Operations
`define INST_ENCODING_ALUR    32'bxxxxxxxxxxxxxxxxx???xxxxx0110011 // ALU Register-to-Register Ops
`define INST_ENCODING_LUI     32'bxxxxxxxxxxxxxxxxxxxxxxxxx0110111 // LUI (Load Upper Immediate)

`define NEXT_PC_FROM_JAL_IMM  2'b01
`define NEXT_PC_FROM_JALR     2'b10
`define NEXT_PC_FROM_BRANCH   2'b01
`define NEXT_PC_PLUS_4        2'b00
`define NEXT_PC_AUIPC         2'b11

// Define macros for the alu instruction selectors (func7 + func3 combined)
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

module decode(inst_encoding, branch_taken, next_pc_sel, mem_rd, mem_wr, alu_src, alu_selector, branch_type, lui_data, reg_write);

input wire [31:0] inst_encoding;
input wire branch_taken;
output reg [1:0] next_pc_sel;
output reg mem_rd;                // Memory read enable
output reg mem_wr;                // Memory write enable
output reg alu_src;               // Selects between immediate and register input for ALU
output reg [9:0] alu_selector;    // ALU operation selector
output reg [2:0] branch_type;
output reg [31:0] lui_data;       // LUI data (upper 20 bits of immediate)
output reg reg_write;             // Register write enable signal

always @(*) begin
    next_pc_sel = `NEXT_PC_PLUS_4;  // Default to PC + 4
    mem_rd = 0;                     // Default: No memory read
    mem_wr = 0;                     // Default: No memory write
    alu_src = 0;                    // Default to register input
    alu_selector = 10'b0;           // Default ALU operation
    branch_type = 3'b000;	    // Default: No branch condition
    lui_data = 32'b0;
    reg_write = 0; 

    casex (inst_encoding)
        // JAL Instruction (Jump and Link)
        `INST_ENCODING_JAL : begin
            next_pc_sel = `NEXT_PC_FROM_JAL_IMM;  // Jump to PC + Immediate
	    reg_write = 1;
        end
            
        // JALR Instruction (Jump and Link Register)
        `INST_ENCODING_JALR : begin
            next_pc_sel = `NEXT_PC_FROM_JALR;  // Jump to address from register (rs1)
	    reg_write = 1;
        end

        // BEQ Instruction (Branch if Equal)
        `INST_ENCODING_BRANCH : begin
	    //alu_selector = {inst_encoding[31:25], inst_encoding[14:12]};  // Set ALU selector for branch comparison
	    case (inst_encoding[14:12])  // funct3
                3'b000: alu_selector = (inst_encoding[31:25] == 7'b0100000) ? `SUB : `ADD;  // ADD/SUB based on funct7
                3'b001: alu_selector = `SLLI;  // SLLI
                3'b100: alu_selector = `XOR;   // XORI
                3'b101: alu_selector = (inst_encoding[31:25] == 7'b0000000) ? `SRLI : `SRAI; // SRLI or SRAI
                3'b110: alu_selector = `OR;    // ORI
                3'b111: alu_selector = `AND;   // ANDI
                default: alu_selector = `ADD;  // Default to ADD
	    endcase
	    branch_type = inst_encoding[14:12];
            if (branch_taken) begin
		next_pc_sel = `NEXT_PC_FROM_BRANCH;
	    end else begin
		next_pc_sel = `NEXT_PC_PLUS_4;
	    end
	    reg_write = 0;
        end

	// AUIPC Instruction (Add Immediate to PC)
        `INST_ENCODING_AUIPC: begin
            next_pc_sel = `NEXT_PC_AUIPC;        // Select PC + Immediate
	    reg_write = 1;
        end

	`INST_ENCODING_LW: begin
	    alu_src = 1;
            mem_rd = 1;                      // Enable memory read
            next_pc_sel = `NEXT_PC_PLUS_4;   // Continue to next instruction
	    reg_write = 1; 
        end

	`INST_ENCODING_SW: begin
	    alu_src = 1;
            mem_wr = 1;                      // Enable memory write
            next_pc_sel = `NEXT_PC_PLUS_4;   // Continue to next instruction
	    reg_write = 0; 
        end

	// i forgot what comment was here lol
        `INST_ENCODING_ALUI: begin
            alu_src = 1;                         // Use immediate value
	    //alu_selector = {inst_encoding[31:25], inst_encoding[14:12]}; 
            case (inst_encoding[14:12])  // funct3
                3'b000: alu_selector = (inst_encoding[31:25] == 7'b0100000) ? `SUB : `ADD;  // ADD/SUB based on funct7
                3'b001: alu_selector = `SLLI;  // SLLI
                3'b100: alu_selector = `XOR;   // XORI
                3'b101: alu_selector = (inst_encoding[31:25] == 7'b0000000) ? `SRLI : `SRAI; // SRLI or SRAI
                3'b110: alu_selector = `OR;    // ORI
                3'b111: alu_selector = `AND;   // ANDI
                default: alu_selector = `ADD;  // Default to ADD
            endcase
	    reg_write = 1;
        end

	// ALU Register-to-Register Operations (ALUR)
        `INST_ENCODING_ALUR: begin
            alu_src = 0;                         // Use register as ALU operand
	    //alu_selector = {inst_encoding[31:25], inst_encoding[14:12]}; 
            case (inst_encoding[14:12])  // funct3
                3'b000: alu_selector = (inst_encoding[31:25] == 7'b0100000) ? `SUB : `ADD;  // ADD/SUB based on funct7
                3'b001: alu_selector = `SLLI;  // SLLI
                3'b100: alu_selector = `XOR;   // XORI
                3'b101: alu_selector = (inst_encoding[31:25] == 7'b0000000) ? `SRLI : `SRAI; // SRLI or SRAI
                3'b110: alu_selector = `OR;    // ORI
                3'b111: alu_selector = `AND;   // ANDI
                default: alu_selector = `ADD;  // Default to ADD
            endcase
	    reg_write = 1;
        end

	// **LUI Instruction (Load Upper Immediate)**
        `INST_ENCODING_LUI: begin
            next_pc_sel = `NEXT_PC_PLUS_4;    // Continue sequential execution
            lui_data = {inst_encoding[31:12], 12'b0};  // Load upper immediate value
	    reg_write = 1;
        end

        // Default Case: Default to PC + 4 (Normal sequential execution)
        default: begin
            next_pc_sel = `NEXT_PC_PLUS_4;  // Default case: Increment PC by 4
	    reg_write = 0;
        end
    endcase
end


endmodule
