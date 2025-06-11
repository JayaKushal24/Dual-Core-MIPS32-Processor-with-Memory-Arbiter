`timescale 1ns / 1ps

module ALU(
    input [31:0] A,             
    input [31:0] B,            
    input [3:0] operation,          
    output reg [31:0] Result,   
    output reg Zero             
);

    always @(A or B or operation) begin
        case (operation)
            4'b0000: Result = A + B;     
            4'b0001: Result = A - B;     
            4'b0010: Result = A & B;   //and 
            4'b0011: Result = A | B; //or
            4'b0100: Result = A ^ B;  //xor
            4'b0101: Result = B << A[4:0];  //logical shift left
            4'b0110: Result = B >> A[4:0];  //logical shift right
            4'b0111: Result = (A < B) ? 32'd1 : 32'd0;
            default: Result = 32'b0;          		
        endcase
           
        Zero = (Result == 32'b0) ? 1 : 0;//to be used for branching op
    end

endmodule
