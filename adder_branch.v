`timescale 1ns / 1ps


module adder_branch(
input [31:0]pc,                    
    input [31:0]branch_jump,                 
    output [31:0]destination     
);

assign destination = pc+ branch_jump;

endmodule