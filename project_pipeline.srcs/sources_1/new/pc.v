`timescale 1ns/1ps
module pc (
           input clk, rst_n,
           input [31:0] pc_in,
           output reg [31:0] pc_out
           );
always @(negedge clk) 
begin
  if (~rst_n)
    pc_out <= 32'h00400000;//gia tri khoi tao vi tri PC
  else
    pc_out <= pc_in;
end
endmodule