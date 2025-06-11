`timescale 1ns / 1ps


module data_memory(
input clk,               
    input rst,               
    input MemRead,           
    input MemWrite,          
    input [31:0]address,    
    input [31:0]write_data, 
    output[31:0]read_data 
);
  reg [31:0]data_memory[31:0];

  integer i;
  assign read_data=(MemRead)? data_memory[address>>2]:32'b00;


  always @(posedge clk or posedge rst) begin
    if (rst ) begin
      for (i=0; i<32; i=i+1) begin
        data_memory[i] = 32'b00;
      end
    end else if (MemWrite) begin
      data_memory[address>>2]=write_data;
    end
  end

endmodule
