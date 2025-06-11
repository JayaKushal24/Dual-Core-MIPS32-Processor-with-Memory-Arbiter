`timescale 1ns / 1ps


module Dual_core_top(
    input clk,
    input rst
    );
//Core 0 to Arbiter signals
wire core0_MemRead, core0_MemWrite, core0_MemRequest, core0_MemGrant;
wire [31:0] core0_MemAddress, core0_MemWriteData, core0_MemReadData;

//Core 1 to Arbiter signals
wire core1_MemRead, core1_MemWrite, core1_MemRequest, core1_MemGrant;
wire [31:0] core1_MemAddress, core1_MemWriteData, core1_MemReadData;

//Arbiter to RAM signals
wire [31:0] ram_addr, ram_wdata, ram_rdata;
wire ram_memwrite, ram_memread;

//Core 0
MIPS32_core0 core0 (
    .clk(clk),
    .rst(rst),
    .MemRead(core0_MemRead),
    .MemWrite(core0_MemWrite),
    .MemAddress(core0_MemAddress),
    .MemWriteData(core0_MemWriteData),
    .MemReadData(core0_MemReadData),
    .MemRequest(core0_MemRequest),
    .MemGrant(core0_MemGrant)
);

//Core 1
MIPS32_core1 core1 (
    .clk(clk),
    .rst(rst),
    .MemRead(core1_MemRead),
    .MemWrite(core1_MemWrite),
    .MemAddress(core1_MemAddress),
    .MemWriteData(core1_MemWriteData),
    .MemReadData(core1_MemReadData),
    .MemRequest(core1_MemRequest),
    .MemGrant(core1_MemGrant)
);
//Arbiter
memory_arbiter arbiter (
    .clk(clk),
    .rst(rst),
    // Core 0
    .core0_req(core0_MemRequest),
    .core0_addr(core0_MemAddress),
    .core0_wdata(core0_MemWriteData),
    .core0_memwrite(core0_MemWrite),
    .core0_memread(core0_MemRead),
    .core0_rdata(core0_MemReadData),
    .core0_grant(core0_MemGrant),
    //Core 1
    .core1_req(core1_MemRequest),
    .core1_addr(core1_MemAddress),
    .core1_wdata(core1_MemWriteData),
    .core1_memwrite(core1_MemWrite),
    .core1_memread(core1_MemRead),
    .core1_rdata(core1_MemReadData),
    .core1_grant(core1_MemGrant),
    //RAM
    .ram_addr(ram_addr),
    .ram_wdata(ram_wdata),
    .ram_memwrite(ram_memwrite),
    .ram_memread(ram_memread),
    .ram_rdata(ram_rdata)
);

//data memory_RAM
data_memory ram (
    .clk(clk),      .rst(rst),  .MemRead(ram_memread),
    .MemWrite(ram_memwrite),    .address(ram_addr),
    .write_data(ram_wdata),     .read_data(ram_rdata)
);





endmodule
