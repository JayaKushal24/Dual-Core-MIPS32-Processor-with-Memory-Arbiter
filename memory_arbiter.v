module memory_arbiter(
    input clk,//global signals
    input rst,
    
    input core0_req,//Core 0 signals
    input [31:0]core0_addr,
    input [31:0]core0_wdata,
    input core0_memwrite,
    input core0_memread,
    output reg [31:0]core0_rdata,
    output reg core0_grant,
    
    input core1_req,//Core 1 signals
    input [31:0]core1_addr,
    input [31:0]core1_wdata,
    input core1_memwrite,
    input core1_memread,
    output reg [31:0]core1_rdata,
    output reg core1_grant,
    
    output reg [31:0]ram_addr,//RAM signals..arbiter output
    output reg [31:0]ram_wdata,
    output reg ram_memwrite,
    output reg ram_memread,
    input [31:0]ram_rdata
);
    reg last_grant; //0 for Core0 and 1 forCore1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            last_grant<=0;
            core0_grant<=0;
            core1_grant<=0;
        end else begin
            if (core0_req && !core1_req) begin
                //Grant Core0
                core0_grant<=1;
                core1_grant<=0;
                last_grant<=0;
            end else if (!core0_req && core1_req) begin
                //Grant Core1
                core0_grant<=0;
                core1_grant<=1;
                last_grant<=1;
            end else if (core0_req && core1_req) begin
                //Both request....toggle access
                if (last_grant==0) begin
                    core0_grant<=0;
                    core1_grant<=1;
                    last_grant<=1;
                end else begin
                    core0_grant<=1;
                    core1_grant<=0;
                    last_grant<=0;
                end
            end else begin
                core0_grant<=0;
                core1_grant<=0;
            end
        end
    end

    //signals to RAM based on grant
    always @(*) begin
        if (core0_grant) begin
            ram_addr=core0_addr;
            ram_wdata=core0_wdata;
            ram_memwrite= core0_memwrite;
            ram_memread= core0_memread;
            core0_rdata=ram_rdata;
            core1_rdata=32'b0;
        end else if (core1_grant) begin
            ram_addr=core1_addr;
            ram_wdata=core1_wdata;
            ram_memwrite= core1_memwrite;
            ram_memread= core1_memread;
            core1_rdata=ram_rdata;
            core0_rdata=32'b0;
        end else begin
            ram_addr=32'b0;
            ram_wdata=32'b0;
            ram_memwrite=0;
            ram_memread=0;
            core0_rdata=32'b0;
            core1_rdata=32'b0;
        end
    end
endmodule
