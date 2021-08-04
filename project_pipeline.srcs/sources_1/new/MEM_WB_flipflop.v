`timescale 1ns / 1ps

module MEM_WB_flipflop
    (     
          input wire clk, rst_n,
          input wire [31:0] wr_next_MEMWB,
          input wire regWen_next_MEMWB,
          input wire [4:0] rd_next_MEMWB,
          output reg regWen_MEMWB,
          output reg [4:0] rd_MEMWB,
          output reg [31:0] wr_MEMWB
          
    );
    
    always@(posedge clk, posedge rst_n)
    begin
       if(~rst_n)
       begin
          regWen_MEMWB <= 0;
          wr_MEMWB  <= 0;
          rd_MEMWB  <= 0;
       end
       else
       begin
          regWen_MEMWB <= regWen_next_MEMWB;
          wr_MEMWB  <= wr_next_MEMWB;
          rd_MEMWB  <= rd_next_MEMWB;
       end
    end
          
endmodule
