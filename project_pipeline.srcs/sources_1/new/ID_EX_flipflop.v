`timescale 1ns / 1ps

module ID_EX_flipflop
    (     
          input wire rst_n, clk,
          input wire MemRW_next_IDEX, Asel_next_IDEX, Bsel_next_IDEX, BrUn_next_IDEX, regWen_next_IDEX,
          input wire [1:0] WBsel_next_IDEX, // output khoi control
          input wire [3:0]  Alu_sel_next_IDEX, //  output khoi control
          input wire [31:0] read_data_1_next_IDEX, read_data_2_next_IDEX,  immgen_next_IDEX, // output cua reg va immgen
          input wire [31:0] pc_next_IDEX, // output cua pc
          input wire [4:0] rd_next_IDEX,  //output cua inst
          output reg [31:0] immgen_IDEX, read_data_1_IDEX, read_data_2_IDEX, pc_IDEX,
           output reg  Asel_IDEX, Bsel_IDEX, BrUn_IDEX, 
          output reg [3:0] Alu_sel_IDEX,
          output reg  MemRW_IDEX, regWen_IDEX,
          output reg [4:0] rd_IDEX,
          output reg [1:0] WBsel_IDEX
    );
    
    
    always @(negedge clk,  negedge rst_n )
    if(~rst_n)
    begin
       immgen_IDEX <= 0;
       read_data_1_IDEX <= 0;
       read_data_2_IDEX <= 0;
       pc_IDEX <= 0;
       Asel_IDEX <= 0;
       Bsel_IDEX <= 0;
       BrUn_IDEX <= 0;
       Alu_sel_IDEX <= 0;
       rd_IDEX <= 0;
       WBsel_IDEX <= 0;
       MemRW_IDEX <= 0;
       regWen_IDEX <= 0;
    end
    else 
    begin
       immgen_IDEX <= immgen_next_IDEX;
       read_data_1_IDEX <= read_data_1_next_IDEX;
       read_data_2_IDEX <= read_data_2_next_IDEX;
       pc_IDEX <= pc_next_IDEX;
       Asel_IDEX <= Asel_next_IDEX;
       Bsel_IDEX <= Bsel_next_IDEX;
       BrUn_IDEX <= BrUn_next_IDEX;
       Alu_sel_IDEX <= Alu_sel_next_IDEX;
       rd_IDEX <= rd_next_IDEX;
       WBsel_IDEX <= WBsel_next_IDEX;
       MemRW_IDEX <= MemRW_next_IDEX;
       regWen_IDEX <= regWen_next_IDEX;
    end
endmodule
