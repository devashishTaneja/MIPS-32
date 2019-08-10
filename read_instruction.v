`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2019 17:55:23
// Design Name: 
// Module Name: read_instruction
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


module read_instruction(
        output reg [31:0] instruction,
        input [31:0] pc
    );
    
    reg [31:0] instructions [255:0];
    
    initial begin 
        $readmemb("instruction.mem", instructions);
    end
    
    always @ (pc)
        begin
            instruction = instructions[pc];
        end
    
endmodule
