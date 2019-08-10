`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2019 18:36:39
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

// https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_help.html
// http://www.dsi.unive.it/~gasparetto/materials/MIPS_Instruction_Set.pdf

// Activity					Signal		Purpose
// PC Update				Branch		Combined with a condition test boolean to enable loading the branch target address into the PC.
// Memory Access			MemRead		Enables a memory read for load instructions.
// 							MemWrite	Enables a memory write for store instructions.
// Register 				RegWrite	Enables a write to one of the registers.
// 							RegDst		Determines how the destination register is specified (rt or rd).
// 							RegRead		Enables a read from one of the registers.

module control_unit(
	output reg RegRead,
		RegWrite,
		MemRead,
		MemWrite,
		RegDst,        // if this is 0 select rt, otherwise select rd
		Branch,
	input [5:0] opcode, func
);
	
	always @(opcode, func) begin
	
		// First, reset all signals
		// J type
		MemRead  = 1'b0;
		MemWrite = 1'b0;
		RegWrite = 1'b0;
		RegRead  = 1'b0;
		RegDst   = 1'b0;
		Branch   = 1'b0;
		
		// R type
		if(opcode == 6'h0)
            begin
                RegDst = 1'b1;
                RegRead = 1'b1;
                // for jr, we have to write to pc
                if(func != 6'h08) 
                    begin
                        RegWrite = 1'b1;
                    end
            end
            
		// For lui, we just have to load rt from imm
		if(opcode != 6'b1111)
            begin
                RegRead = 1'b1;
            end
		
		// For R-type, beq, bne, sb, sh and sw there is no need to register write
		if(opcode != 6'h0 & opcode != 6'h4 & opcode != 6'h5 & opcode != 6'h28 & opcode != 6'h29 & opcode != 6'h2b) 
			begin
				RegWrite = 1'b1;
				RegDst   = 1'b0;
			end

		// For branch instructions
		if(opcode == 6'h4 | opcode == 6'h5) 
            begin
                Branch = 1'b1;
            end

		// For memory write operation {sb, sh and sw}
		if(opcode == 6'h28 | opcode == 6'h29 | opcode == 6'h2b) 
            begin
                MemWrite = 1'b1;
                RegRead  = 1'b1;
            end

		// For memory read operation {lb, lh, lw, lbu and lhu}
		if( (opcode == 6'h20) | (opcode == 6'h21) | (opcode == 6'h22) | (opcode == 6'h24) | (opcode == 6'h25))
			begin
				MemRead = 1'b1;
				RegWrite = 1'b1;
				RegDst   = 1'b0;
			end
	end
	
endmodule
