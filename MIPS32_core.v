`timescale 1ns / 1ps

module MIPS32_core0(
    input clk,
    input rst,
    output MemRead,//arbiter interface
    output MemWrite,
    output [31:0] MemAddress,
    output [31:0] MemWriteData,
    input [31:0] MemReadData,
    output MemRequest, // request
    input MemGrant
);

// Wires
wire [31:0] pc_wire, pc_out_wire, pc_next_wire, decode_wire, read_data1, read_data2;
wire [31:0] reg_mux_alu_out, sign_extension_out, ALU_result, write_data, Adder_result, jump_address, pc_next;
wire [4:0] write_reg_mux;
wire [1:0] ALUOp;
wire [3:0] operation;
wire RegDst, RegWrite, ALUSrc, MemRead_wire, MemWrite_wire, MemToReg, Branch, Zero, Jump;

//STALL: pause on mem op if arbiter denies ---
wire is_mem_instr=MemRead_wire|MemWrite_wire;
wire stall=is_mem_instr&~MemGrant;

//PC only updates if not stalled ---
program_counter PC(
    .clk(clk), .reset(rst), .stall(stall), .pc(pc_wire), .next_pc(pc_out_wire)
);

// PC Adder
pc_add PC_Adder(
    .pc_in(pc_out_wire), .pc_out(pc_next_wire)
);

// PC mux
mux2x1 pc_mux(
    .in0(pc_next), .in1(Adder_result), .sel(Branch&Zero), .out(pc_wire)
);

// Instruction memory
instruction_memory_Core0 Instr_Mem(
    .reset(rst), .clk(clk), .read_address(pc_out_wire), .instruction(decode_wire)
);

// Write register mux
mux2x1_5b wr_reg_mux(
    .in0(decode_wire[20:16]), .in1(decode_wire[15:11]), .sel(RegDst), .out(write_reg_mux)
);

//Reg write disabled if stalled
registerts Reg_mem(
    .clk(clk),
    .reg_write(RegWrite&~stall),//Reg write disabled if stalled
    .write_data(write_data),
    .write_register(write_reg_mux),
    .read_register1(decode_wire[25:21]),
    .read_register2(decode_wire[20:16]),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Sign extend
sign_extend sign_ext(
    .in(decode_wire[15:0]), .out(sign_extension_out)
);

// ALU input mux
mux2x1 reg_mux_alu(
    .in0(read_data2), .in1(sign_extension_out), .sel(ALUSrc), .out(reg_mux_alu_out)
);

// Control unit
control control(
    .opcode(decode_wire[31:26]), .RegWrite(RegWrite), .MemRead(MemRead_wire), .MemWrite(MemWrite_wire),
    .MemToReg(MemToReg), .ALUSrc(ALUSrc), .Branch(Branch), .RegDst(RegDst), .ALUOp(ALUOp), .Jump(Jump)
);

// ALU control
ALUControl alu_control(
    .funct(decode_wire[5:0]), .ALUOp(ALUOp), .operation(operation)
);

// ALU
ALU alu_block(
    .A(read_data1), .B(reg_mux_alu_out), .operation(operation), .Result(ALU_result), .Zero(Zero)
);

//Mem write only if not stalled..specifically for dual core 
assign MemRead=MemRead_wire;
assign MemWrite=MemWrite_wire&~stall;
assign MemAddress=ALU_result;
assign MemWriteData=read_data2;
assign MemRequest=MemRead_wire|MemWrite_wire;

// Use MemReadData from arbiter as the memory read result
wire [31:0] mem_read_data;
assign mem_read_data=MemReadData;

// Mem to Reg Mux
mux2x1 datmem_mux_regmem(
    .in0(ALU_result), .in1(mem_read_data),
    .sel(MemToReg), .out(write_data)
);

// Branch address adder 
adder_branch adder(
    .pc(pc_next_wire), .branch_jump(sign_extension_out<<2), .destination(Adder_result)
);

// Jump address logic
Jump jump_unit(
    .pc_plus_4(pc_next_wire), .instr_index(decode_wire[25:0]), .jump_address(jump_address)
);

mux2x1 jump_mux(
    .in0(pc_next_wire), .in1(jump_address), .sel(Jump), .out(pc_next)
);

endmodule
