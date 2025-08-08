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
    output reg [32:0] instruction
);
    reg [32:0] mem [0:255];
    
    integer i;
    initial begin
    // Initialize memory with 0s
        $readmemh("instruction_memory.hex", mem);
    end
    
    always @* begin
        instruction <= mem[address];
    end
endmodule
