`timescale 1ns / 1ps

module control(
    input [5:0]opcode,         
    output reg RegWrite,        
    output reg MemRead,         
    output reg MemWrite,        
    output reg MemToReg,        
    output reg ALUSrc,          
    output reg Branch,          
    output reg RegDst,    
     output reg Jump,//for jump instr      
    output reg [1:0] ALUOp      
);

    always @(*) begin
        case (opcode)
            6'b000000: //R type
            begin
                RegDst= 1'b1;ALUSrc= 1'b0;MemToReg= 1'b0;RegWrite= 1'b1;
                MemRead= 1'b0;MemWrite= 1'b0;Branch= 1'b0;ALUOp= 2'b10;Jump = 1'b0;
            end

            6'b100011: // lw
            begin
                RegDst= 1'b0;ALUSrc= 1'b1;MemToReg= 1'b1;RegWrite= 1'b1;
                MemRead= 1'b1;MemWrite= 1'b0;Branch= 1'b0;ALUOp= 2'b00;Jump = 1'b0;
            end

            6'b101011: // sw
            begin
                RegDst= 1'bx;ALUSrc= 1'b1;MemToReg= 1'bx;RegWrite= 1'b0;
                MemRead= 1'b0;MemWrite= 1'b1;Branch= 1'b0;ALUOp= 2'b00; Jump = 1'b0; // ALU performs add to cal address
            end

            6'b000100: // beq
            begin
                RegDst= 1'bx;ALUSrc= 1'b0;MemToReg= 1'bx;RegWrite= 1'b0;
                MemRead= 1'b0;MemWrite= 1'b0;Branch= 1'b1;ALUOp= 2'b01;Jump = 1'b0;
            end

            6'b001000: // addi (I-type ALU immediate)
            begin
                RegDst= 1'b0;ALUSrc= 1'b1;MemToReg= 1'b0;RegWrite= 1'b1;
                MemRead= 1'b0;MemWrite= 1'b0;Branch= 1'b0;ALUOp= 2'b00;  //ADD
                Jump = 1'b0;
            end
            6'b000010: begin // jump instruction
            RegDst= 1'b0;ALUSrc= 1'b0;MemToReg= 1'b0;RegWrite= 1'b0;
                MemRead= 1'b0;MemWrite= 1'b0;Branch= 1'b0;ALUOp= 2'b00;Jump = 1'b1;
end
            default: 
            begin
                RegDst= 1'b0;ALUSrc= 1'b0;MemToReg= 1'b0;RegWrite= 1'b0;
                MemRead= 1'b0;MemWrite= 1'b0;Branch= 1'b0;ALUOp= 2'b00;Jump = 1'b0;
            end
        endcase
    end



endmodule
