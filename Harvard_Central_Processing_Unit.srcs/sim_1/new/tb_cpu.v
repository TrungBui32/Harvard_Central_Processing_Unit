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

        uut.imem.mem[0] = 16'b0000001000000101;  // LI R1,5: [0000.000.0.00000101]
        uut.imem.mem[1] = 16'b0000010000001010;  // LI R2,10: [0000.010.0.00001010]
//        uut.imem.mem[2] = 16'b; // ST 
//        uut.imem.mem[2] = 16'b0011010001000000; // ADD R2, R0, R: [0011.010.001.000.000]
//        uut.imem.mem[2] = 16'b0000011000000010;  // LI R3,2: [0000.011.0.00000010]
        uut.imem.mem[3] = 16'b0000100000000011;  // LI R4,3: [0000.100.0.00000011]
        uut.imem.mem[4] = 16'b0011101010001000;  // ADD R5, R2, R3: [0011.101.010.011.000]
//        uut.imem.mem[5] = 16'b0100110101100000; // SUB R6, R5, R4: [0100.110.101.100.000]
//        uut.imem.mem[2] = 16'h3408;  // ADD R2,R0,R1: [0011][010][000][001][xxxx]
//        uut.imem.mem[3] = 16'h4608;  // SUB R3,R0,R1: [0100][011][000][001][xxxx]
//        uut.imem.mem[4] = 16'h080A;  // LI R4,10: [0000][100][00001010]
        // store value in R4 to address stored in R5 
        uut.imem.mem[5] = 16'b0010101100000000;  // ST R4,R5: [0010.101.100.000.000] 
        // store value in R2 to address stored in R1
        uut.imem.mem[6] = 16'b0010001010000000;
        // load value stored in address in R5 to R7
//        uut.imem.mem[7] = 16'b0001111101000000;  // LD R5,R7: [0001.111.101.000000]
        uut.imem.mem[7] = 16'b0001110001000000; // LD R1, R6
        
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
        $display("stored value = %d", uut.dmem.mem[15]);
        $display("stored value = %d", uut.dmem.mem[10]);
                        
        // Check assertions
//        if (uut.reg_file.registers[0] !== 8'h05) 
//            $error("R0 value incorrect");
//            $display("R0: %b", uut.reg_file.registers[0]);
//        if (uut.reg_file.registers[1] !== 8'h0A) 
//            $error("R1 value incorrect");
//        if (uut.reg_file.registers[2] !== 8'h0F) 
//            $error("R2 value incorrect (5+10=15)");
//        if (uut.reg_file.registers[3] !== 8'hF9) 
//            $error("R3 value incorrect (5-10=-5 in 2's complement)");
//        if (uut.reg_file.registers[4] !== 8'h0A) 
//            $error("R4 value incorrect");
//        if (uut.reg_file.registers[5] !== 8'h0F) 
//            $error("R5 value incorrect");
//        if (uut.dmem.mem[10] !== 8'h0F) 
//            $error("Memory[10] value incorrect");
        
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | PC: %b | Instruction: %b | Accumulator: %d",
                 $time, uut.debug_pc, uut.debug_instruction, uut.debug_accumulator);
    end
endmodule