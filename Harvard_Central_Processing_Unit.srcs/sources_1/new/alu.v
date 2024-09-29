`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 12:09:34 PM
// Design Name: 
// Module Name: alu
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


module alu (
    input wire clk,
    input wire reset,
    input wire [3:0] alu_op,
    input wire [7:0] operand1,
    input wire [7:0] operand2,
    input wire [7:0] immediate,
    output reg [7:0] result,
    output reg [7:0] debug_accumulator
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'b0;
            debug_accumulator <= 8'b0;
        end else begin
            case (alu_op)
                4'b0000: result <= immediate; // Load immediate
                4'b0001: result <= operand1 + operand2; // Add
                4'b0010: result <= operand1 - operand2; // Subtract
                4'b0011: result <= operand1 & operand2; // AND
//                4'b0100: result <= operand1 | operand2; // OR
//                4'b0101: result <= operand1 ^ operand2; // XOR
//                4'b0110: result <= ~operand1; // NOT
//                4'b0111: result <= operand1 << operand2[2:0]; // Shift left
//                4'b1000: result <= operand1 >> operand2[2:0]; // Shift right
                default: result <= operand1;
            endcase
            debug_accumulator <= result;
        end
    end

endmodule
