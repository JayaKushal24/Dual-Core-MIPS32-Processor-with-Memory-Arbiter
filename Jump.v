`timescale 1ns / 1ps

module Jump(
    input  [31:0]pc_plus_4, 
    input  [25:0]instr_index,  
    output [31:0]jump_address    
);

    assign jump_address = {pc_plus_4[31:28],instr_index,2'b00};

endmodule
