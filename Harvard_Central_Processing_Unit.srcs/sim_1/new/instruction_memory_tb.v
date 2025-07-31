`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2025 11:02:14 AM
// Design Name: 
// Module Name: instruction_memory_tb
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


module instruction_memory_tb;
    reg clk;
    reg [7:0] address;
    wire [15:0] instruction;
    
    instruction_memory uut (
        .clk(clk), .address(address), .instruction(instruction)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $display("=== INSTRUCTION MEMORY TESTBENCH ===");
        
        // Load test data
        uut.mem[0] = 16'hABCD;
        uut.mem[1] = 16'h1234;
        uut.mem[2] = 16'h5678;
        
        // Test immediate response
        address = 8'h00; #1;
        $display("Time %0t: Addr 0 - Expected: ABCD, Got: %h %s", 
                 $time, instruction, (instruction == 16'hABCD) ? "PASS" : "FAIL");
        
        address = 8'h01; #1;
        $display("Time %0t: Addr 1 - Expected: 1234, Got: %h %s", 
                 $time, instruction, (instruction == 16'h1234) ? "PASS" : "FAIL");
        
        address = 8'h02; #1;
        $display("Time %0t: Addr 2 - Expected: 5678, Got: %h %s", 
                 $time, instruction, (instruction == 16'h5678) ? "PASS" : "FAIL");
        
        #20; $finish;
    end
endmodule
