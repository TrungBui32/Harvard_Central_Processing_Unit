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
    input wire [4:0] alu_op,
    input wire [7:0] operand1,
    input wire [7:0] operand2,
    input wire [7:0] immediate,
    output reg [7:0] result,
    output reg [7:0] debug_accumulator,
    output reg zero_flag,          // Zero flag for branches
    output reg carry_flag         // Carry flag for arithmetic
);
    always @(*) begin
        carry_flag = 1'b0;  // Default no carry
        case (alu_op)
            // Group 1: Data Movement (00000-00011)
            5'b00000: result = immediate;           // MOVI - Load immediate
            5'b00001: result = operand1;            // MOV - Pass operand1
            5'b00010: result = operand2;            // MOV - Pass operand2
            5'b00011: result = {operand1[3:0], operand2[3:0]}; // PACK - Combine nibbles
            
            // Group 2: Arithmetic (00100-00111)
            5'b00100: {carry_flag, result} = operand1 + operand2;       // ADD
            5'b00101: {carry_flag, result} = operand1 - operand2;       // SUB
            5'b00110: result = operand1 + 1;                            // INC
            5'b00111: result = operand1 - 1;                            // DEC
            
            // Group 3: Logical (01000-01011)
            5'b01000: result = operand1 & operand2;     // AND
            5'b01001: result = operand1 | operand2;     // OR
            5'b01010: result = operand1 ^ operand2;     // XOR
            5'b01011: result = ~operand1;               // NOT
            
            // Group 4: Shifts (01100-01111)
            5'b01100: result = operand1 << 1;               // SHL1
            5'b01101: result = operand1 >> 1;               // SHR1
            5'b01110: result = operand1 << operand2[2:0];   // SHLV
            5'b01111: result = operand1 >> operand2[2:0];   // SHRV
            
            // Group 5: Arithmetic Shifts (10000-10011)
            5'b10000: result = $signed(operand1) >>> 1;             // ASR1
            5'b10001: result = $signed(operand1) >>> operand2[2:0]; // ASRV
            5'b10010: result = {operand1[6:0], operand1[7]};        // ROR1
            5'b10011: result = {operand1[0], operand1[7:1]};        // ROL1
            
            // Group 6: Comparisons (10100-10111)
            5'b10100: result = (operand1 == operand2) ? 8'h01 : 8'h00;  // CMPEQ
            5'b10101: result = (operand1 != operand2) ? 8'h01 : 8'h00;  // CMPNE
            5'b10110: result = (operand1 < operand2)  ? 8'h01 : 8'h00;  // CMPLT
            5'b10111: result = (operand1 >= operand2) ? 8'h01 : 8'h00;  // CMPGE
            
            // Group 7: Bit Operations (11000-11011)
            5'b11000: result = operand1 | (1 << operand2[2:0]);     // BSET
            5'b11001: result = operand1 & ~(1 << operand2[2:0]);    // BCLR
            5'b11010: result = operand1 ^ (1 << operand2[2:0]);     // BTOG
            5'b11011: result = (operand1 >> operand2[2:0]) & 1;     // BTST
            
            // Group 8: Special Functions (11100-11111)
            5'b11100: result = operand1 + operand2 + carry_flag;    // ADDC
            5'b11101: result = operand1 - operand2 - carry_flag;    // SUBC
            5'b11110: result = operand1 * operand2[3:0];            // MULLO
            5'b11111: result = (operand1 * operand2) >> 8;          // MULHI
            
            default: result = operand1;
        endcase
        
        zero_flag = (result == 8'h00);
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debug_accumulator <= 8'b0;
        end else begin
            debug_accumulator <= result;
        end
    end
endmodule
