`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2019 18:52:36
// Design Name: 
// Module Name: alu_unit
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

module alu_unit(res, sig_branch, opcode, rs_content, rt_content, shamt, ctrl, immediate);
	
	input [5:0] ctrl, opcode;
	input [4:0] shamt; // shamt
	input [15:0] immediate;
	input [31:0] rs_content, rt_content; //inputs
	
	output reg sig_branch;
	output reg [31:0] res; //output
	
	integer i;
	
	// temp for sra command
	reg signed [31:0] temp, signed_rs, signed_rt; 
	reg [31:0] signExtend, zeroExtend;

	always @ (ctrl, rs_content, rt_content, shamt, immediate)
		begin
			// signed value assigment
			signed_rs = rs_content;
			signed_rt = rt_content;
				
			// R-type instruction
			if(opcode == 6'h0)
	            begin
	                case(ctrl)
	                    6'h20 : //add
	                        res = signed_rs + signed_rt;
	                    6'h21 : //addu
	                        res = rs_content + rt_content;
	                    6'h22 : //sub
	                        res = signed_rs - signed_rt;
	                    6'h23 : //subu
	                        res = rs_content - rt_content;	
	                    6'h24 : //and
	                        res = rs_content & rt_content;	
	                    6'h25 : //or
	                        res = rs_content | rt_content;
	                    6'h27 : //nor
	                        res = ~(rs_content | rt_content);			
	                    6'h03 : //sra
	                        begin
	                            temp = rt_content;
	                            for(i = 0; i < shamt; i = i + 1) begin
	                                temp = {temp[31],temp[31:1]};
	                            end
	                            res = temp;
	                        end	
	                    6'h02 : //srl
	                        res = (rt_content >> shamt);
	                    6'h00 : //sll
	                        res = (rt_content << shamt);
	                    6'h2b : //sltu
	                        begin
	                            if(rs_content < rt_content)
	                                begin
	                                    res = 1;
	                                end
	                            else
	                                begin
	                                    res = 0;
	                                end
	                        end    
	                    6'h2a : //slt
	                        begin
	                            if(signed_rs < signed_rt)
	                                begin
	                                    res = 1;
	                                end
	                            else 
	                                begin
	                                    res = 0;
	                                end
	                        end
	                endcase //case
	            end // if
	         
			// I type
	        else
	            begin
				signExtend = {{16{immediate[15]}}, immediate};
				zeroExtend = {{16{1'b0}}, immediate};
				
				case(opcode)
					6'h8 : // addi
						res = signed_rs + signExtend;		
					6'h9 : // addiu
						res = rs_content + signExtend;
					6'b010010 : // andi
						res = rs_content & zeroExtend;
					6'h4 : // beq
						begin
							// if the result is zero, they are equal go branch!
							res = signed_rs - signed_rt;
							if(res == 0)
	                            begin
	                                sig_branch = 1'b1;
	                            end
							else
	                            begin
	                                sig_branch = 1'b0;
	                            end
	                    end
					
					6'h5 : // bne
						begin
							// if the result is not zero, they are not equal go branch!
							res = signed_rs - signed_rt;
							if(res != 0) begin
								sig_branch = 1'b1;
								res = 1'b0;
							end
							else begin
								sig_branch = 1'b0;
							end
						end
					
					6'b010101 : // lui
						res = {immediate, {16{1'b0}}};
					
					6'b010011 : // ori
						res = rs_content | zeroExtend;
					
					6'b001010 : // slti
						begin
							if(signed_rs < $signed(signExtend))
	                            begin
	                                res = 1;
	                            end
							else
	                            begin
	                                res = 0;
	                            end
						end
					
					6'b001011 : // sltiu
						begin
							if(rs_content < signExtend) 
	                            begin
	                                res= 1;
	                            end
	                        else
	                            begin
	                                res = 0;
	                            end
						end
					6'h28 : // sb
						res = signed_rs + signExtend;
					6'h29 : // sh
						res = signed_rs + signExtend;
					6'h2b : // sw
						res = signed_rs + signExtend;
					6'h23 : // lw
						res = signed_rs + signExtend;
					6'h24 : // lbu
						res = signed_rs + signExtend;
					6'h25 : // lhu
						res = signed_rs + signExtend;
					6'h30 : // ll
						res = signed_rs + signExtend;
					
				endcase
			end
		end
	
	
	initial begin
		$monitor("opcode: %6b, Rs content: %32b, rt content: %32b, signExtendImm = %32b, result: %32b\n",
		opcode, rs_content, rt_content, signExtend, ALU_result);
	end
	
endmodule