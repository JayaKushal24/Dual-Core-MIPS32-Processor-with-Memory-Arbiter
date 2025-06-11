`timescale 1ns / 1ps

module instruction_memory_Core1(
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
        mem[0]  = 32'h20080003; // addi $t0, $zero, 3      ; $t0 = 3
        mem[1]  = 32'h20090007; // addi $t1, $zero, 7      ; $t1 = 7
        mem[2]  = 32'h01095020; // add  $t2, $t0, $t1      ; $t2 = $t0 + $t1 = 10
        mem[3]  = 32'h01285822; // sub  $t3, $t1, $t0      ; $t3 = $t1 - $t0 = 4
        mem[4]  = 32'hAC0A0010; // sw   $t2, 16($zero)     ; mem[4] = 10
        mem[5]  = 32'hAC0B0014; // sw   $t3, 20($zero)     ; mem[5] = 4
        mem[6]  = 32'h8C0C0010; // lw   $t4, 16($zero)     ; $t4 = 10
        mem[7]  = 32'h8C0D0014; // lw   $t5, 20($zero)     ; $t5 = 4
        mem[8]  = 32'h018D7020; // add  $t6, $t4, $t5      ; $t6 = $t4 + $t5 = 14
        mem[9]  = 32'h01CD7822; // sub  $t7, $t6, $t5      ; $t7 = $t6 - $t5 = 10
        mem[10] = 32'hAC0E0018; // sw   $t6, 24($zero)     ; mem[6] = 14
        mem[11] = 32'hAC0F001C; // sw   $t7, 28($zero)     ; mem[7] = 10
        mem[12] = 32'h8C080000; // lw   $t0, 0($zero)      ; $t0 = (should be 15, written by core 0)
        mem[13] = 32'h8C090004; // lw   $t1, 4($zero)      ; $t1 = (should be 5, written by core 0)
        mem[14] = 32'h01095020; // add  $t2, $t0, $t1      ; $t2 = $t0 + $t1 = 20


    end

    always @(*) begin
        instruction=mem[read_address>>2]; //might have to divide  by 4 here...depending onn value initialization
    end

endmodule
