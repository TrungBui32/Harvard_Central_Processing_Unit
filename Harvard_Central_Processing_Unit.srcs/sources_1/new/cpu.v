`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 12:09:34 PM
// Design Name: 
// Module Name: cpu
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


module cpu (
    input wire clk,
    input wire reset,
    output wire [7:0] debug_pc,
    output wire [15:0] debug_instruction,
    output wire [7:0] debug_accumulator
);
    // Internal signals
    wire [15:0] instruction;
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire [7:0] address;
    wire mem_write_enable, mem_read_enable;
    wire [3:0] alu_op;
    wire [7:0] immediate;
    wire [7:0] reg_write_data;
    wire reg_write_enable;
    wire [2:0] reg_write_addr, reg_read_addr1, reg_read_addr2;
    wire [7:0] reg_read_data1, reg_read_data2;
    
    // Data memory input multiplexer
//    wire [7:0] data_in_mux = mem_write_enable ? reg_read_data2 : data_out;
    wire [7:0] data_in_mux = mem_write_enable ? reg_read_data2 : data_out;
    // Instantiate control unit
    control_unit cu (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .mem_write_enable(mem_write_enable),
        .mem_read_enable(mem_read_enable),
        .alu_op(alu_op),
        .immediate(immediate),
        .reg_write_enable(reg_write_enable),
        .reg_write_addr(reg_write_addr),
        .reg_read_addr1(reg_read_addr1),
        .reg_read_addr2(reg_read_addr2),
        .debug_pc(debug_pc)
    );
    
    // Instantiate ALU
    alu alu_unit (
        .clk(clk),
        .reset(reset),
        .alu_op(alu_op),
        .operand1(reg_read_data1),
        .operand2(reg_read_data2),
        .immediate(immediate),
        .result(data_out),
        .debug_accumulator(debug_accumulator)
    );
    
    // Instantiate register file
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .write_enable(reg_write_enable),
        .write_addr(reg_write_addr),
        .write_data(reg_write_data),
        .read_addr1(reg_read_addr1),
        .read_addr2(reg_read_addr2),
        .read_data1(reg_read_data1),
        .read_data2(reg_read_data2)
    );
    
    // Instantiate instruction memory
    instruction_memory imem (
        .clk(clk),
        .address(debug_pc),
        .instruction(instruction)
    );
    
    // Instantiate data memory
    data_memory dmem (
        .clk(clk),
        .address(address),
        .write_enable(mem_write_enable),
        .read_enable(mem_read_enable),
        .data_in(data_in_mux),
        .data_out(data_in)
    );
    
    // Connect address to ALU output
    assign address = data_out;
    
    // Multiplexer for register write data
    assign reg_write_data = mem_read_enable ? data_in : data_out;
    
    // Debug output
    assign debug_instruction = instruction;
endmodule
