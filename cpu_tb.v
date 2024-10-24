`timescale 1us/100ns

module cpu_tb();

    // Testbench signals
    reg clk_tb, rst_tb;

    // Instantiate the CPU
    cpu cpu_inst (
        .clk(clk_tb),
        .rst(rst_tb)
    );

    // Clock generation: 100 MHz clock (10ns period)
    always begin
        #5 clk_tb = ~clk_tb;  // Toggle clock every 5 time units for a 10 time unit period
    end

    initial begin
        // Initialize clock and reset
        clk_tb = 0;
        rst_tb = 1;

        // Deassert reset after some time to allow memory loading
        #10;
        rst_tb = 0;  // Release reset and let the CPU start executing

        // Run the simulation for some time
        #5000;

        // Display some register contents for debugging or verification purposes
        $display("Register x1: %h", cpu_inst.rf.registers[1]);  // Example: checking register x1
        $display("Register x2: %h", cpu_inst.rf.registers[2]);

        // End simulation
        $stop;
    end
endmodule

