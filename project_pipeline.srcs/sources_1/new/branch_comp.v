module branch_comp (input [31:0] rs1, rs2,
                    input BrUn,//BrUn so sanh khong dau Unsigned
                    output reg BrEq, BrLt); // so sanh rs1 voi rs2: rs1?rs2
wire [31:0] rs1_n, rs2_n;
assign rs1_n= (~rs1) +1;//rs1_n = bu 2 cua rs1
assign rs2_n= (~rs2) +1;


always @(BrUn, rs1, rs2) begin
  if (BrUn==1'b1) begin// so sanh khong dau
    if (rs1 < rs2) begin
      BrLt = 1'b1;// <
      BrEq = 1'b0;
    end
    else if (rs1 == rs2) begin
      BrEq= 1'b1;// = 
      BrLt= 1'bx;  
    end
    else begin
      BrEq= 1'b0;
      BrLt= 1'b0;
    end
  end
  else begin// so sanh co dau
    case ({rs1[31], rs2[31]})// set bit dau rs1 va rs2 
      2'b10: begin //rs1<0, rs2>0 => rs2 > rs1 => be hon
               BrLt= 1'b1;
               BrEq= 1'b0;
             end
      2'b01: begin //rs1 >0, rs2 <0 =>  rs1 > rs2 => lon hon
               BrLt= 1'b0;
               BrEq= 1'b0;
             end
      2'b00:   begin            // rs1, rs2 >0 => so sanh 2 so duong
               if (rs1 < rs2) begin
                 BrLt = 1'b1;
                 BrEq = 1'b0;
               end
               else if (rs1 == rs2) begin
                 BrEq= 1'b1;
                 BrLt= 1'bx;
               end
               else begin
                 BrEq= 1'b0;
                 BrLt= 1'b0;
               end
               end
      2'b11: begin// so sanh 2 so am
              if (rs1_n < rs2_n) begin// so sanh 2 so bu 2 sau khi khu dau am
                BrLt = 1'b0;// bu 2 rs1 > bu 2 rs2 => -rs1 > -rs1 => lon hon
                BrEq = 1'b0;
              end
              else if (rs1_n == rs2_n) begin// equal
                BrEq= 1'b1;
                BrLt= 1'bx;
              end
              else begin// lessthan
                BrEq= 1'b0;
                BrLt= 1'b1;
              end
            end
    endcase
  end
end
endmodule


  alu_sel= 4'b0000;
  in1= 32'h0000000a;
  in2= 32'h0000000a;
  #20;
  alu_sel= 4'b0001;
  #20;
  alu_sel= 4'b0010;
  #20;
  alu_sel= 4'b0011;
  #20;
  alu_sel=4'b0110;
  #20;
  alu_sel=4'b0111;
  #20;
  alu_sel=4'b0101;
  #20;
  alu_sel=4'b1000;
  #20;
  alu_sel=4'b1001;



















