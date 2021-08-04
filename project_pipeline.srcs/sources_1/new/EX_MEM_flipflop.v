`timescale 1ns / 1ps

module EX_MEM_flipflop
    (   
        input wire rst_n, clk,
        input wire [1:0] WBsel_next_EXMEM, // output cua control
        input wire  MemRW_next_EXMEM, // output cua control
        input wire  regWen_next_EXMEM,
        input wire [4:0] rd_next_EXMEM,
        input wire [31:0] Alu_out_next_EXMEM, rs2_next_EXMEM, pc_next_EXMEM,
        output reg MemRW_EXMEM, regWen_EXMEM,
        output reg [31:0] Alu_out_EXMEM, rs2_EXMEM, pc_EXMEM,
        output reg [1:0]  WBsel_EXMEM,
        output reg [4:0] rd_EXMEM
    );
    
     always @(negedge clk, negedge rst_n)
    if(~rst_n)
    begin
       Alu_out_EXMEM <= 0;
       pc_EXMEM <= 0;
       rs2_EXMEM <= 0;
       rd_EXMEM <= 0;
       WBsel_EXMEM <= 0;
       MemRW_EXMEM <= 0;
       regWen_EXMEM <= 0;
    end
    else
    begin
       Alu_out_EXMEM <= Alu_out_next_EXMEM;
       pc_EXMEM <= pc_next_EXMEM;
       rs2_EXMEM <= rs2_next_EXMEM;
       rd_EXMEM <= rd_next_EXMEM;
       WBsel_EXMEM <= WBsel_next_EXMEM;
       MemRW_EXMEM <= MemRW_next_EXMEM;
       regWen_EXMEM <= regWen_next_EXMEM;
     end
endmodule
