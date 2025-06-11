`timescale 1ns / 1ps

///used between registers memory(after) and ALU(before)

///used between data memory (after) and registers memory(before)

module mux2x1 (
    input [31:0]in1,   
    input [31:0]in0,   
    input sel,          
    output [31:0]out      
);

    assign out= sel? in1:in0;  

endmodule


//used between  instruction memroy(after) and register memory(before)
module mux2x1_5b(
    input [4:0]in1,   
    input [4:0]in0,   
    input sel,          
    output [4:0]out      
);

    assign out= sel? in1:in0;  

endmodule
