`timescale 1us/100ns
module regfile(rs1, rs2, rd, write_data, write_enable, clk, rst, read_data1, read_data2);

    input wire [4:0] rs1;             // Read register 1 address
    input wire [4:0] rs2;             // Read register 2 address
    input wire [4:0] rd;              // Write register address
    input wire [31:0] write_data;     // Data to write
    input wire write_enable;          // Write enable signal
    input wire clk;                   // Clock signal
    input wire rst;                   // Reset signal
    output wire [31:0] read_data1;    // Output for register 1 data
    output wire [31:0] read_data2;    // Output for register 2 data

    // Declare an array of 32 register entries (32-bit wide)
    wire [31:0] registers [31:0];

    // Manually instantiate 32 regentry modules (one for each register)
    regentry reg_inst_0  (.D(32'b0),      .clk(clk), .rst(rst), .write_enable(1'b0), .Q(registers[0]));  // Register 0 is always zero
    regentry reg_inst_1  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00001)), .Q(registers[1]));
    regentry reg_inst_2  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00010)), .Q(registers[2]));
    regentry reg_inst_3  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00011)), .Q(registers[3]));
    regentry reg_inst_4  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00100)), .Q(registers[4]));
    regentry reg_inst_5  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00101)), .Q(registers[5]));
    regentry reg_inst_6  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00110)), .Q(registers[6]));
    regentry reg_inst_7  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b00111)), .Q(registers[7]));
    regentry reg_inst_8  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01000)), .Q(registers[8]));
    regentry reg_inst_9  (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01001)), .Q(registers[9]));
    regentry reg_inst_10 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01010)), .Q(registers[10]));
    regentry reg_inst_11 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01011)), .Q(registers[11]));
    regentry reg_inst_12 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01100)), .Q(registers[12]));
    regentry reg_inst_13 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01101)), .Q(registers[13]));
    regentry reg_inst_14 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01110)), .Q(registers[14]));
    regentry reg_inst_15 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b01111)), .Q(registers[15]));
    regentry reg_inst_16 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10000)), .Q(registers[16]));
    regentry reg_inst_17 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10001)), .Q(registers[17]));
    regentry reg_inst_18 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10010)), .Q(registers[18]));
    regentry reg_inst_19 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10011)), .Q(registers[19]));
    regentry reg_inst_20 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10100)), .Q(registers[20]));
    regentry reg_inst_21 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10101)), .Q(registers[21]));
    regentry reg_inst_22 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10110)), .Q(registers[22]));
    regentry reg_inst_23 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b10111)), .Q(registers[23]));
    regentry reg_inst_24 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11000)), .Q(registers[24]));
    regentry reg_inst_25 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11001)), .Q(registers[25]));
    regentry reg_inst_26 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11010)), .Q(registers[26]));
    regentry reg_inst_27 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11011)), .Q(registers[27]));
    regentry reg_inst_28 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11100)), .Q(registers[28]));
    regentry reg_inst_29 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11101)), .Q(registers[29]));
    regentry reg_inst_30 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11110)), .Q(registers[30]));
    regentry reg_inst_31 (.D(write_data), .clk(clk), .rst(rst), .write_enable(write_enable & (rd == 5'b11111)), .Q(registers[31]));


    // Instantiate multiplexers for the read ports
    mux32 mux1 (
        .in(registers), 
        .sel(rs1), 
        .out(read_data1)
    );

    mux32 mux2 (
        .in(registers), 
        .sel(rs2), 
        .out(read_data2)
    );

endmodule
