`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 10:13:15 PM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();

    reg clk;
    reg reset;
    reg [3:0] alu_op;
    reg [7:0] operand1;
    reg [7:0] operand2;
    reg [7:0] immediate;
    wire [7:0] result;
    wire [7:0] debug_accumulator;
    
    alu dut (
        .clk(clk),
        .reset(reset),
        .alu_op(alu_op),
        .operand1(operand1),
        .operand2(operand2),
        .immediate(immediate),
        .result(result),
        .debug_accumulator(debug_accumulator)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        
        reset = 1;
        #10;
        reset = 0;
        
        #20;
        
        // Test case 1: Immediate
        alu_op = 4'h0;
        immediate = 8'h15;
        @(posedge clk);
        @(negedge clk);
        if(result === 8'h15)
            $display("Test case 1 passed");
        else
            $display("Test case 1 failed, got %h", result);
        
        // Test case 2: Addition
        alu_op = 4'h1;
        operand1 = 8'h11;
        operand2 = 8'h22;
        @(posedge clk);
        @(negedge clk);
        if(result === 8'h33)
            $display("Test case 2 passed");
        else
            $display("Test case 2 failed, got %h", result);
        
        // Test case 3: Subtraction
        alu_op = 4'h2;
        operand1 = 8'h22;
        operand2 = 8'h11;
        @(posedge clk);
        @(negedge clk);
        if(result === 8'h11)
            $display("Test case 3 passed");
        else
            $display("Test case3 failed, got %h", result);
            
        // Test case 4: AND - 1
        alu_op = 4'h3;
        operand1 = 8'h1;
        operand2 = 8'h0;
        @(posedge clk);
        @(negedge clk);
        if(result === 8'h0)
            $display("Test case 4 passed");
        else
            $display("Test case 4 failed, got %h", result);

        // Test case 5: AND - 5
        alu_op = 4'h3;
        operand1 = 8'h1;
        operand2 = 8'h1;
        @(posedge clk);
        @(negedge clk);
        if(result === 8'h1)
            $display("Test case 5 passed");
        else
            $display("Test case 5 failed, got %h", result);
            
        // End simulation
        #20;
        $display("Simulation completed");
        $finish;
    end

endmodule
