`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 12:09:34 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory (
    input wire clk,
    input wire [7:0] address,
    output reg [15:0] instruction
);
    reg [15:0] mem [0:255];
    
//    initial begin
//        $readmemb("program.bin", mem); 
//    end
    integer i;
    initial begin
    // Initialize memory with some values
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 16'd0;
            end
    end
    
    always @* begin
        instruction <= mem[address];
    end
endmodule
