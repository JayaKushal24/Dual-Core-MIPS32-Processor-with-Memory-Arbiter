`timescale 1ns / 1ps

module program_counter(
    input clk,
    input reset,
    input stall, ///////////////extra logic
    input [31:0]pc,
    output reg [31:0]next_pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            next_pc<=32'b0;        
        else if(!stall) 
            next_pc<=pc;//pc is not directly incremented..as there might be branch and jump instructions
    end
endmodule