`timescale 1us/100ns
module cpu(clk, rst);

input wire clk, rst;
wire [31:0] pc;
wire [31:0] inst_encoding;

wire [31:0] rf_out_0;
wire [31:0] rf_out_1;

wire [31:0] immediate;

wire branch_taken;                // Zero flag from ALU
wire [31:0] alu_result;        // Result from ALU
wire [31:0] lui_data;

wire [1:0] pc_sel;
wire pc_write_enable;
reg [31:0] next_pc;

wire [31:0] data_mem_out;  // Data read from memory
wire mem_rd, mem_wr;       // Memory read and write enables

wire [2:0] branch_type;

// ALU Control Signals
wire alu_src;           // ALU source control (immediate or register)
wire [9:0] alu_selector;  // ALU operation selector

wire [31:0] pc_plus_4 = pc + 32'd4;             // PC + 4
wire [31:0] pc_plus_imm = pc + immediate;       // PC + immediate (for branches)
wire [31:0] pc_from_rf = rf_out_0;              // PC from register file (JALR) 

always @(*) begin
    case (pc_sel)
        2'b00: next_pc = pc_plus_4;      // Standard increment by 4
        2'b01: next_pc = pc_plus_imm;    // Branching or jumping with immediate
        2'b10: next_pc = pc_from_rf;     // Jump or return address (JALR)
        default: next_pc = pc_plus_4;    // Default case: increment by 4
    endcase
end

assign pc_write_enable = 1'b1;

// MUX for ALU Input 2
wire [31:0] alu_in1;
assign alu_in1 = alu_src ? immediate : rf_out_1;

// MUX for Write-back to Register File
reg [31:0] write_data;

always @(*) begin
    case (inst_encoding[6:0])  // Opcode field to determine instruction type
        7'b0000011: begin  // Load Word (LW)
            write_data = data_mem_out;  // Memory load
        end
        7'b0110111: begin  // LUI (Load Upper Immediate)
            write_data = lui_data;  // Immediate load (LUI)
        end
        7'b0010111: begin  // AUIPC (Add Upper Immediate to PC)
            write_data = pc_plus_imm;  // PC + Immediate load
        end
        7'b1101111: begin  // JAL (Jump and Link)
            write_data = pc_plus_4;  // Write PC + 4 for JAL
        end
        7'b1100111: begin  // JALR (Jump and Link Register)
            write_data = pc_plus_4;  // Write PC + 4 for JALR
        end
        default: begin
            write_data = alu_result;  // Default to ALU result for other instructions
        end
    endcase
end
                       // ALU load

regentry pc_reg (.D(next_pc), 
    		 .clk(clk), 
    		 .rst(rst), 
    		 .write_enable(pc_write_enable), 
    		 .Q(pc));

memory2c imem(.data_out(inst_encoding), 
	      .data_in(32'b0), 
	      .addr(pc), 
	      .enable(1'b1), 
	      .wr(1'b0), 
	      .createdump(1'b0), 
	      .clk(clk), 
	      .rst(rst));

memory2c dmem (.data_out(data_mem_out), 
               .data_in(rf_out_1), 
               .addr(alu_result), 
               .enable(mem_rd | mem_wr), 
               .wr(mem_wr), 
               .createdump(1'b0), 
               .clk(clk), 
               .rst(rst));

regfile rf(.rs1(inst_encoding[19:15]), 
	   .rs2(inst_encoding[24:20]), 
	   .rd(inst_encoding[11:7]), 
	   .write_data(write_data), 
	   .write_enable(reg_write), 
	   .clk(clk), 
	   .rst(rst), 
	   .read_data1(rf_out_0), 
	   .read_data2(rf_out_1));

// ALU instantiation: Handles arithmetic and logical operations
alu alu_inst (.in0(rf_out_0),              		// First operand from register file
	      .in1(alu_in1),     // Second operand from register file or immediate
              .selector(alu_selector),      		// Selector: func7 + func3
              .branch_taken(branch_taken),        		// Zero flag output
              .out(alu_result),             		// ALU result output
              .c_out());		    		// Carry out (optional, not used)

 decode decode_logic (.inst_encoding(inst_encoding), // Current instruction
		      .branch_taken(branch_taken),    // Branch decision from ALU
        	      .next_pc_sel(pc_sel),          // Controls next PC value
        	      .mem_rd(mem_rd),               // Memory read enable
        	      .mem_wr(mem_wr),               // Memory write enable
        	      .alu_src(alu_src),             // Selects ALU operand source (immediate or register)
        	      .alu_selector(alu_selector),   // ALU operation selector
		      .branch_type(branch_type),     // Branch condition type
		      .lui_data(lui_data),           // LUI data output
		      .reg_write(reg_write));        // Register write enable

immediate_decoder imm_dec (.instruction(inst_encoding),
			   .immediate(immediate));

endmodule
