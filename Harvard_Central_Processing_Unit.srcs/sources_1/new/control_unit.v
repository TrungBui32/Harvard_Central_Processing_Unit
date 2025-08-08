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
        input wire [31:0] instruction,
        input wire zero_flag,
        output reg mem_write_enable,
        output reg mem_read_enable,
        output reg [4:0] alu_op,
        output reg [7:0] immediate,
        output reg reg_write_enable,
        output reg [2:0] reg_write_addr,
        output reg [2:0] reg_read_addr1,
        output reg [2:0] reg_read_addr2,
        output wire [7:0] debug_pc
    );
        
        reg [7:0] program_counter;
        
        // Instruction field definitions
        wire [4:0] opcode = instruction[31:27];  // 5-bit opcode
        wire [2:0] rd = instruction[26:24];      // Destination register
        wire [2:0] rs1 = instruction[23:21];     // Source register 1
        wire [2:0] rs2 = instruction[20:18];     // Source register 2
        wire [2:0] funct = instruction[17:15];   // Function field
        wire [7:0] imm = instruction[7:0];       // Immediate value

        always @(posedge clk or posedge reset) begin
            if (reset) begin
                program_counter <= 8'b0;
                // Reset all control signals
                mem_write_enable <= 1'b0;
                mem_read_enable <= 1'b0;
                alu_op <= 5'b00000;
                immediate <= 8'b0;
                reg_write_enable <= 1'b0;
                reg_write_addr <= 3'b000;
                reg_read_addr1 <= 3'b000;
                reg_read_addr2 <= 3'b000;
            end else begin                
                // Default values for all control signals
                mem_write_enable <= 1'b0;
                mem_read_enable <= 1'b0;
                alu_op <= 5'b00000;
                immediate <= 8'b0;
                reg_write_enable <= 1'b0;
                reg_write_addr <= 3'b000;
                reg_read_addr1 <= 3'b000;
                reg_read_addr2 <= 3'b000;
                
                // Instruction decoding
                case (opcode)   
                    // Data Transfer Instructions
                    5'b00000: begin // MOVI - Load immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        immediate <= imm;
                        alu_op <= 5'b00000;  // MOVI operation
                    end
                    5'b00001: begin // MOV - Register copy
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        alu_op <= 5'b00001;  // Pass operand1
                    end
                    
                    // Memory Access Instructions
                    
                    5'b00010: begin // LOAD - Load from memory
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;  // Address
                        mem_read_enable <= 1'b1;
                        alu_op <= 5'b00001;  // Pass address (operand1)
                    end
                    
                    5'b00011: begin // STORE - Store to memory
                        reg_read_addr1 <= rs1;  // Address
                        reg_read_addr2 <= rs2;  // Data
                        mem_write_enable <= 1'b1;
                        alu_op <= 5'b00001;    // Pass address
                    end
                    
                    // Arithmetic Instructions
                    
                    5'b00100: begin // ADD
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b00100;  // ADD
                    end
                    
                    5'b00101: begin // ADDI - Add immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        immediate <= imm;
                        alu_op <= 5'b00100;  // ADD (uses immediate)
                    end
                    
                    5'b00110: begin // SUB
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b00101;  // SUB
                    end
                    
                    5'b00111: begin // SUBI - Subtract immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        immediate <= imm;
                        alu_op <= 5'b00101;  // SUB (uses immediate)
                    end
                    
                    5'b01000: begin // INC - Increment
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        alu_op <= 5'b00110;  // INC
                    end
                    
                    5'b01001: begin // DEC - Decrement
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        alu_op <= 5'b00111;  // DEC
                    end
                    
                    // Logical Instructions
                    5'b01010: begin // AND
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b01000;  // AND
                    end
                    
                    5'b01011: begin // OR
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b01001;  // OR
                    end
                    
                    5'b01100: begin // XOR
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b01010;  // XOR
                    end
                    
                    5'b01101: begin // NOT
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        alu_op <= 5'b01011;  // NOT
                    end
                    
                    // Shift Instructions
                    
                    5'b01110: begin // SHL - Shift left logical
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b01110;  // SHLV
                    end
                    
                    5'b01111: begin // SHLI - Shift left by immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        immediate <= imm;
                        alu_op <= 5'b01110;  // SHLV (uses immediate)
                    end
                    
                    5'b10000: begin // SHR - Shift right logical
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b01111;  // SHRV
                    end
                    
                    5'b10001: begin // SHRI - Shift right by immediate
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        immediate <= imm;
                        alu_op <= 5'b01111;  // SHRV (uses immediate)
                    end
                    
                    5'b10010: begin // ASR - Arithmetic shift right
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10001;  // ASRV
                    end
                    
                    // Comparison Instructions
                    5'b10011: begin // CMPEQ - Compare equal
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10100;  // CMPEQ
                    end
                    
                    5'b10100: begin // CMPNE - Compare not equal
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10101;  // CMPNE
                    end
                    
                    5'b10101: begin // CMPLT - Compare less than
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10110;  // CMPLT
                    end
                    
                    5'b10110: begin // CMPGE - Compare greater or equal
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10111;  // CMPGE
                    end
                    
                    // Bit Manipulation Instructions
                    5'b10111: begin // BSET - Bit set
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b11000;  // BSET
                    end
                    
                    5'b11000: begin // BCLR - Bit clear
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b11001;  // BCLR
                    end
                    
                    // Control Flow Instructions
                    5'b11001: begin // BEQ - Branch if equal
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10100;  // CMPEQ
                        // Branch logic would be implemented here
                        if (zero_flag) begin
                            program_counter <= program_counter + imm;  // PC-relative
                        end else begin
                            program_counter <= program_counter + 1;
                        end
                    end
                    
                    5'b11010: begin // BNE - Branch if not equal
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b10101;  // CMPNE
                        // Branch logic would be implemented here
                        if (!zero_flag) begin
                            program_counter <= program_counter + imm;
                        end else begin
                            program_counter <= program_counter + 1;
                        end
                    end
                    
                    // Special Instructions
                    5'b11110: begin // MULLO - Multiply low byte
                        reg_write_enable <= 1'b1;
                        reg_write_addr <= rd;
                        reg_read_addr1 <= rs1;
                        reg_read_addr2 <= rs2;
                        alu_op <= 5'b11110;  // MULLO
                    end
                    default: begin
                        alu_op <= 5'b0000;
                    end
                endcase
                program_counter <= program_counter + 1;
            end
        end
        
        assign debug_pc = program_counter;
    endmodule