`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2019 20:46:30
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




module read_data(
	output reg [31:0] read_data,
	input  [31:0] address,write_data,
	input [5:0] opcode,
	input sig_mem_read,sig_mem_write
);
	
	reg [31:0] data_mem [255:0];
	
	initial 
        begin
            $readmemb("data.mem", data_mem);
        end
	
	always @(address)
        begin
            if(sig_mem_write)
                begin
                    if(opcode == 6'h28)
                        begin
                            data_mem[address][7:0] = write_data[7:0];
                        end
                    else if(opcode == 6'h29)
                        begin
                            data_mem[address][15:0] = write_data[15:0];
                        end
                    else
                        begin
                            data_mem[address] = write_data;
                        end
                    // write to file
                    $writememb("data.mem", data_mem);
                end
        end
	
	always @(address) begin
		if(sig_mem_read)
            begin
                read_data = data_mem[address];
            end
	end
	
	
//	initial begin
//		$monitor("yaz?lacak address: %32b, yaz?lacak bilgi: %32b\n",
//		address, write_data);
//	end
	
endmodule