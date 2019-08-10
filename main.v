`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.01.2019 10:12:45
// Design Name: 
// Module Name: main
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

module mips32(clk);

	input clk;
	
	reg[31:0] pc = 32'b0;
	wire [31:0] instruction;
	
	// Parse instruction
	wire [5:0] func;
	wire [4:0] rs, rt, rd, shamt;
	wire [25:0] address;
	wire [15:0] immediate;
	wire [5:0] opcode;
	
	// Signals
	wire read_reg_signal, write_reg_signal, regDst_signal;
	wire read_mem_signal, write_mem_signal;
	wire branch_signal;
	
	// Registers contents
	wire [31:0] data, rs_content, rt_content, memory_read_data;
	
	
	// Read the instruction
	read_instruction inst_read (instruction, pc);
	
	inst_parser parse (opcode, rs, rt, rd, shamt, func, immediate, address, instruction);
	
	control_unit cu (read_reg_signal, write_reg_signal,read_mem_signal, write_mem_signal, regDst_signal, 
								 branch_signal, opcode, func);
								 
	alu_unit alu (data, branch_signal, opcode, rs_content, rt_content, shamt, func, immediate);
	
	read_data rw (memory_read_data, data, rt_content, opcode, read_mem_signal, write_mem_signal);
	
	read_register content (rs_content, rt_content, data, rs, rt, rd, opcode, 
									read_reg_signal, write_reg_signal, regDst_signal, clk);
	
	// PC operations
	always @(posedge clk) 
        begin 
            // jump 
            if(opcode == 6'h2)
                begin
                    pc = address;
                end

            // jr
            else if(opcode == 6'h0 & func == 6'h08)
                begin
                    pc = rs_content;
                end

            // branch
            else if(data == 0 & branch_signal == 1)
                begin
                    pc = pc + 1 + $signed(immediate); 
                end
                
            // incr pc 
            else 
                begin
                    pc = pc+1;
                end
	end 
	
    //	initial begin
    //		$monitor("instruction: %32b, PC: %32b\n",
    //		instruction, PC);
    //	end
	
endmodule
