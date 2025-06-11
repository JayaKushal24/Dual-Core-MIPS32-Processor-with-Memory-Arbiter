`timescale 1ns / 1ps


module registerts(
input clk,
input [31:0]write_data,
input [4:0]write_register,read_register1,read_register2,
input reg_write,
output [31:0]read_data1,read_data2
    );
    
 reg [31:0] register_mem[31:0];
 
 integer i;
    initial begin
        for (i=0; i<32; i=i+1)
            register_mem[i] = 32'd0;
    end 
 always @(posedge clk)begin
 
     if (reg_write && write_register!=0)begin //1st register is 0(fixed in MIPS)
        register_mem[write_register]=write_data;
     end 
  end
     assign read_data1=register_mem[read_register1];
     assign read_data2=register_mem[read_register2];
 
    
endmodule
