`timescale 1ns / 1ps

module ALUControl(
    input [1:0] ALUOp,           //output from Control
    input [5:0] funct,           //from instruction[5:0] for r type
    output reg [3:0] operation  
);

    always @(*) begin
        case (ALUOp)
            2'b00: operation = 4'b0000; //lw,sw,addi..add
            2'b01: operation = 4'b0001; //beq => SUBTRACT

            2'b10: begin  //for r type ...decode funct field
                case (funct)
                    6'b100000: operation = 4'b0000; //add
                    6'b100010: operation = 4'b0001; //sub
                    6'b100100: operation = 4'b0010; //and
                    6'b100101: operation = 4'b0011; //or
                    6'b101010: operation = 4'b0111; //slt
                    6'b100110: operation = 4'b0100; //xor
                    6'b000000: operation = 4'b0101; //Shift left logical
                    6'b000010: operation = 4'b0110; //shift right logical
                    default:   operation = 4'b0000;
                endcase
            end

            default: operation = 4'b0000; 
        endcase
    end

endmodule
