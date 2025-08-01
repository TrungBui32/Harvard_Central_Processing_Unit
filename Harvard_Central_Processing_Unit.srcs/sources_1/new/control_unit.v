    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 09/29/2024 12:09:34 PM
    // Design Name: 
    // Module Name: control_unit
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
    
    
module control_unit (
        input wire clk,
        input wire reset,
        input wire [15:0] instruction,
        output reg mem_write_enable,
        output reg mem_read_enable,
        output reg [3:0] alu_op,
        output reg [7:0] immediate,
        output reg reg_write_enable,
        output reg [2:0] reg_write_addr,
        output reg [2:0] reg_read_addr1,
        output reg [2:0] reg_read_addr2,
        output wire [7:0] debug_pc
    );
        
        reg [7:0] program_counter;
        
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                program_counter <= 8'b0;
                // Reset all control signals
                mem_write_enable <= 1'b0;
                mem_read_enable <= 1'b0;
                alu_op <= 4'b0000;
                immediate <= 8'b0;
                reg_write_enable <= 1'b0;
                reg_write_addr <= 3'b000;
                reg_read_addr1 <= 3'b000;
                reg_read_addr2 <= 3'b000;
            end else begin
//                program_counter <= program_counter + 1;
                
                // Default values for all control signals
                mem_write_enable <= 1'b0;
                mem_read_enable <= 1'b0;
                alu_op <= 4'b0000;
                immediate <= 8'b0;
                reg_write_enable <= 1'b0;
                reg_write_addr <= 3'b000;
                reg_read_addr1 <= 3'b000;
                reg_read_addr2 <= 3'b000;
                
                // Instruction decoding
                case (instruction[15:12])
                    4'b0000: begin // Load immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= instruction[11:9];
                        immediate <= instruction[7:0];
                        alu_op <= 4'b0000;
                    end
                    4'b0001: begin // Load from memory
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= instruction[11:9];
                        reg_read_addr1 <= instruction[8:6];
                        mem_read_enable <= 1'b1;
                        alu_op <= 4'b0100;
                    end
                    4'b0010: begin // Store to memory
                        reg_read_addr1 <= instruction[11:9];
                        reg_read_addr2 <= instruction[8:6];
                        mem_write_enable <= 1'b1;
                        alu_op <= 4'b0100;
                    end
                    4'b0011: begin // Add
//                        reg_write_enable <= 1'b1;
//                        reg_write_addr <= instruction[11:9];
                        reg_read_addr1 <= instruction[8:6];
                        reg_read_addr2 <= instruction[5:3];
                        alu_op <= 4'b0001;
                        reg_write_addr <= instruction[11:9];
                        reg_write_enable <= 1'b1;
                    end
                    4'b0100: begin // Subtract
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= instruction[11:9];
                        reg_read_addr1 <= instruction[8:6];
                        reg_read_addr2 <= instruction[5:3];
                        alu_op <= 4'b0010;
                    end
                    default: begin
                        alu_op <= 4'b0000;
                    end
                endcase
                program_counter <= program_counter + 1;

            end
        end
        
        assign debug_pc = program_counter;
    endmodule