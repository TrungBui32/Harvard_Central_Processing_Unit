`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 11:27:25 AM
// Design Name: 
// Module Name: tb_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module tb_cpu;
    reg clk;
    reg reset;
    
    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .debug_pc(),
        .debug_instruction(),
        .debug_accumulator()
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period (100MHz)
    end

    // Test procedure
    initial begin
        // Initialize inputs
        reset = 1'b1;
        #20;
        reset = 1'b0;
        
        // R0 should not be used due to instruction format
        
        uut.imem.mem[0] = 16'b0000001000000100;  // LD R1,4: [0000.000.0.00000101] => R1 = 4
        uut.imem.mem[1] = 16'b0000010000001010;  // LD R2,10: [0000.010.0.00001010] => R2 = 10
        uut.imem.mem[2] = 16'b0100100010001000;  // SUB R4, R2, R1: [0100.100.010.001.000] => R4 = 6
        uut.imem.mem[3] = 16'b0011101010001000;  // ADD R5, R2, R1: [0011.101.010.011.000]  => R5 = 14
        // store value in R4 to address stored in R5 
        uut.imem.mem[4] = 16'b0010101100000000;  // ST R4,R5: [0010.101.100.000.000] => mem[14] = 6
        // store value in R2 to address stored in R1
        uut.imem.mem[5] = 16'b0010001010000000;  // ST R2, R1: [0010.001.010.000.000] => mem[4] = 10
        // load value stored in address in R5 to R7
        uut.imem.mem[6] = 16'b0001111101000000;  // LD R5, R7: [0001.111.101.000000] => R7 = 6
        // load value stored in address in R1 to R6
        uut.imem.mem[7] = 16'b0001110001000000; // LD R1, R6: [0001.110.001.000000] => R6 = 10
        
        // Run simulation
        #150; // Let CPU execute 15 cycles
                
        // Check results
        $display("Final Register Values:");
        $display("R0 = %d", uut.reg_file.registers[0]);
        $display("R1 = %d", uut.reg_file.registers[1]);
        $display("R2 = %d", uut.reg_file.registers[2]);
        $display("R3 = %d", uut.reg_file.registers[3]);
        $display("R4 = %d", uut.reg_file.registers[4]);
        $display("R5 = %d", uut.reg_file.registers[5]);
        $display("R6 = %d", uut.reg_file.registers[6]);
        $display("R7 = %d", uut.reg_file.registers[7]);
        $display("stored value in mem[14] = %d", uut.dmem.mem[14]);
        $display("stored value in mem[4] = %d", uut.dmem.mem[4]);
                        
        // Check assertions
        if (uut.reg_file.registers[0] !== 8'd0) begin
            $error("R0 value incorrect");
            $display("R0: %d", uut.reg_file.registers[0]);
        end else if (uut.reg_file.registers[1] !== 8'd4) begin 
            $error("R1 value incorrect");
            $display("R1: %d", uut.reg_file.registers[1]);
        end else if (uut.reg_file.registers[2] !== 8'd10) begin 
            $error("R2 value incorrect");
            $display("R2: %d", uut.reg_file.registers[2]);
        end else if (uut.reg_file.registers[3] !== 8'd0) begin 
            $error("R3 value incorrect");
            $display("R3: %d", uut.reg_file.registers[3]);
        end else if (uut.reg_file.registers[4] !== 8'd6) begin 
            $error("R4 value incorrect");
            $display("R4: %d", uut.reg_file.registers[4]);
        end else if (uut.reg_file.registers[5] !== 8'd14) begin 
            $error("R5 value incorrect");
            $display("R5: %d", uut.reg_file.registers[5]);
        end else if (uut.reg_file.registers[6] !== 8'd10) begin 
            $error("R6 value incorrect");
            $display("R6: %d", uut.reg_file.registers[6]);
        end else if (uut.reg_file.registers[7] !== 8'd6) begin 
            $error("R7 value incorrect");
            $display("R6: %d", uut.reg_file.registers[7]);
        end else if (uut.dmem.mem[14] !== 6) begin
            $error("mem[14] value incorrect");
            $display("mem[14]: %d", uut.dmem.mem[14]);
        end else if (uut.dmem.mem[4] !== 10) begin
            $error("mem[4] value incorrect");
            $display("mem[4]: %d", uut.dmem.mem[4]);
        end else begin
            $display("Passed");
        end
        
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | PC: %b | Instruction: %b | Accumulator: %d",
                 $time, uut.debug_pc, uut.debug_instruction, uut.debug_accumulator);
    end
endmodule