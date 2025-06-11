`timescale 1ns / 1ps

module instruction_memory_Core0(
    input clk, reset,
    input [31:0]read_address,
    output reg [31:0]instruction
);

    reg [31:0]mem[63:0];
    integer i;

    initial begin
        for (i=0; i<64; i=i+1)
            mem[i] = 32'h00000000;
///////instructions are modified to verify the dual core fucntionality

        mem[0]  = 32'h20080005; // addi $t0, $zero, 5      ; $t0 = 5
        mem[1]  = 32'h2009000A; // addi $t1, $zero, 10     ; $t1 = 10
        mem[2]  = 32'h01095020; // add  $t2, $t0, $t1      ; $t2 = $t0 + $t1 = 15
        mem[3]  = 32'h01285822; // sub  $t3, $t1, $t0      ; $t3 = $t1 - $t0 = 5
        mem[4]  = 32'hAC0A0000; // sw   $t2, 0($zero)      ; mem[0] = 15
        mem[5]  = 32'hAC0B0004; // sw   $t3, 4($zero)      ; mem[1] = 5
        mem[6]  = 32'h8C0C0000; // lw   $t4, 0($zero)      ; $t4 = 15
        mem[7]  = 32'h8C0D0004; // lw   $t5, 4($zero)      ; $t5 = 5
        mem[8]  = 32'h018D7020; // add  $t6, $t4, $t5      ; $t6 = $t4 + $t5 = 20
        mem[9]  = 32'h01CD7822; // sub  $t7, $t6, $t5      ; $t7 = $t6 - $t5 = 15
        mem[10] = 32'hAC0E0008; // sw   $t6, 8($zero)      ; mem[2] = 20
        mem[11] = 32'hAC0F000C; // sw   $t7, 12($zero)     ; mem[3] = 15
        mem[12] = 32'h8C080008; // lw   $t0, 8($zero)      ; $t0 = 20
        mem[13] = 32'h8C09000C; // lw   $t1, 12($zero)     ; $t1 = 15
        mem[14] = 32'h01095022; // sub  $t2, $t0, $t1      ; $t2 = $t0 - $t1 = 5

    end

    always @(*) begin
        instruction=mem[read_address>>2]; //might have to divide  by 4 here...depending onn value initialization
    end

endmodule
