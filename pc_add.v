`timescale 1ns / 1ps


module pc_add(
input [31:0]pc_in,
output [31:0]pc_out
    );
    assign pc_out =  pc_in+4;
endmodule
