`timescale 1ns / 1ps

module IF_ID_flipflop(
            input wire rst_n, clk,
            input wire [31:0] pc_next_IFID, inst_next_IFID,
            output reg [31:0] pc_IFID, inst_IFID
    );
    
    always @(negedge clk, negedge rst_n )
    if(~rst_n)
    begin
       pc_IFID <= 0;
       inst_IFID <= 0;
    end
    else 
    begin
       pc_IFID <= pc_next_IFID;
       inst_IFID <= inst_next_IFID;
    end
endmodule
