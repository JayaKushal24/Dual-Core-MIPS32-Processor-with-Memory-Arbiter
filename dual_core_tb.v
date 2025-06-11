`timescale 1ns / 1ps


module dual_core_tb;

    // Inputs
    reg clk;
    reg rst;

    Dual_core_top dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        rst = 1;
        #20;
        rst = 0;
        #500;

        $finish;
    end


endmodule

