module top (
             input clk, rst_n
           );
  //==================================Khoi IFID ===================================
  //I/O PCmux khoi 1to2
  wire [31:0] alu_out, pc_add4, pc_mux_out;// pc_mux_out = pcmux(pc_out)
  wire  pc_sel;
    //neu pc_sel = 1 thi chon alu_out , khong thi chon gia tri dua ra tu khoi pcadd4
    pc_mux PCmux (.alu_out(alu_out), .pc_add4(pc_add4), .pc_sel(pc_sel), .pc_out(pc_mux_out));
    
  //I/O PC
  wire [31:0] pc_out;
	//clk, rst_n khoi reset gia tri pc khi !rst_n pc_out <= 32'h00400000
	// else pc_out <= pc_in = pc_mux_out = pcmux(pc_out)
    pc PC (.clk(clk), .rst_n(rst_n), .pc_in(pc_mux_out), .pc_out(pc_out));
     //khoi PC + 4 pc
// khi co gia tri PC_in thi tang PC len 4   
    pc_add4 pc_add (.pc_in(pc_out), .pc_out(pc_add4));
    
//I/O IMEM thay doi gia tri khi co gia tri PC moi
//cau lenh instruction duoc lay ra tu bo nhom IMEM boi gia tri cua khoi PC
// PC duoc chia thanh 2 gia tri pWord va pByte
  wire [31:0] inst_IMEM, pc_ID_IF, inst_ID_IF;
    READ_IMEM IMEM (.PC(pc_out), .inst(inst_IMEM));
    
    IF_ID_flipflop IFID(.clk(clk), .rst_n(rst_n), .pc_next_IFID(pc_out), .inst_next_IFID(inst_IMEM), .pc_IFID(pc_ID_IF), .inst_IFID(inst_ID_IF));
  //I/O regs khoi lua chon thanh ghi cho dataA, dataB va gia tri write back
  wire RegWen;
  //rs1 tu bit 15-19 cua instruction vaf rs tu 20-14, toan hang dich duoc luu va thanh ghi co gia tri bit 7-11 cua instruction
  // gia tri write back duoc dua vao tu khoi WriteBackSelect
//gia tri Register Write enable duoc trigger boi khoi controller cho phep ghi vao thanh ghi
//khi cho phep ghi vao thanh ghi gia tri rd duoc luu vao vi tri cua gia tri wb
  wire [31:0] wb, dataA, dataB;
  wire [4:0] rd_MEMWB;
  wire regWen_MEMWB;
    regs regs (.clk(clk), .rst_n(rst_n), .rs1(inst_ID_IF[19:15]), .rs2(inst_ID_IF[24:20]), .rd(rd_MEMWB), .RegWen(regWen_MEMWB), .wb(wb), .dataA(dataA), .dataB(dataB));
  //============================================Khai bao day cho cac khoi sau =============================
  // Day noi/
  //I/O branch_comp
  wire BrUn, BrLt, BrEq;
  // Dau ra imm
  wire [31:0] imm_out;
  // trigger B_sel tu khoi controller
  wire B_sel; 
   //chon giua 2 gia tri PC va gia tri toan hang 1 rs1 tu khoi reg[]
  wire A_sel;  
   //I/O alu khoi chon cac che do va dau vao khoi ALU
  wire [3:0] alu_sel;
  // gia tri MemRW trigger cho phep viet hoac doc tu khoi controller
  wire MemRW;
  //I/O mux_W khoi chon WriteBack vao khoi Reg cho dataD
  wire [1:0] WBsel;
  // day 
  
  
  
  //===========================Khoi IDEX ===================================================//
  wire [31:0] immgen_IDEX, read_data_1_IDEX, read_data_2_IDEX, pc_IDEX, Asel_IDEX, Bsel_IDEX, BrUn_IDEX, rd_IDEX, WBsel_IDEX, regWen_IDEX, MemRW_IDEX;
  wire [3:0] Alu_sel_IDEX;
   // ID/EX flipflop 
  ID_EX_flipflop IDEX(.clk(clk), .rst_n(rst_n), .WBsel_next_IDEX(WBsel),.MemRW_next_IDEX(MemRW), .Asel_next_IDEX(A_sel), .Bsel_next_IDEX(B_sel),.BrUn_next_IDEX(BrUn), .regWen_next_IDEX(RegWen),.Alu_sel_next_IDEX(alu_sel),.read_data_1_next_IDEX(dataA), .read_data_2_next_IDEX(dataB), .immgen_next_IDEX(imm_out),.pc_next_IDEX(pc_ID_IF),  .rd_next_IDEX(inst_ID_IF[11:7]),   
                        .immgen_IDEX(immgen_IDEX),.read_data_1_IDEX(read_data_1_IDEX), .read_data_2_IDEX(read_data_2_IDEX), .pc_IDEX(pc_IDEX), .Asel_IDEX(Asel_IDEX), .Bsel_IDEX(Bsel_IDEX), .BrUn_IDEX(BrUn_IDEX), .rd_IDEX(rd_IDEX),.Alu_sel_IDEX(Alu_sel_IDEX), .WBsel_IDEX(WBsel_IDEX), .MemRW_IDEX(MemRW_IDEX), .regWen_IDEX(regWen_IDEX)  );
  //I/O imm_gen khoi tao ra gi tri tuc thi immediate gen
  wire [2:0] imm_sel;// gia tri immediate select duoc lay ra tu khoi controller de chon cac loai immediate
	// nhu I, S, B, U, J, R formar

//immediate input la 26 bit cuoi cua cau lenh instuctrion se duoc cat ra ung voi moi loai format
//trong khoi immgen nay sex noi dau cho immediate
//ngo ra la 1 so co dau 32 bit
    imm_gen imm_gen (.imm_in(inst_ID_IF[31:7]), .imm_sel(imm_sel), .imm_out(imm_out));
    

  //so sanh 2 gia tri dau vao dataA va dataB, cho do co dau hoac khong dau
//ngo ra la gia tri Branch Equal hoac Branch Lessthan
// neu so sanh co dau thi 2 toan hang duoc bu 2 de so sanh va doi dau  
    branch_comp branch_comp (.rs1(read_data_1_IDEX), .rs2(read_data_2_IDEX), .BrUn(BrUn_IDEX), .BrEq(BrEq), .BrLt(BrLt));
  
  //I/O mux_A khoi chon gia tri toan hang 1 cho khoi ALU

  wire [31:0] muxA_out;
    muxA mux_A (.pc(pc_IDEX), .rs1(read_data_1_IDEX), .A_sel(Asel_IDEX), .muxA_out(muxA_out));
    
    
  //I/O mux_B chon giua 2 gia tri immediate out tu khoi immgen hoac toan hang 2 tu khoi reg[] rs2

  wire [31:0] muxB_out;
    muxB mux_B (.imm(immgen_IDEX), .rs2(read_data_2_IDEX), .B_sel(Bsel_IDEX), .muxB_out(muxB_out));
    
 
  //lay cac gia tri dau ra cua 2 khoi muxA va muxB la cac toan hang
  //tu khoi controler cac operation duoc dua vao khoi ALU bang bien alu_select
   //gia tri ngo ra duoc luu vao bien alu_out
    alu alu (.in1(muxA_out), .in2(muxB_out), .alu_sel(Alu_sel_IDEX), .alu_out(alu_out));
    
    
    
    
    
    
 //==============================================Khoi EXMEM ==============================================
 // Dat output cho flipflop
 wire [1:0] WBsel_EXMEM;
 wire MemRW_EXMEM, regWen_EXMEM;
 wire [4:0] rd_EXMEM;
 wire [31:0] Alu_out_EXMEM, rs2_EXMEM, pc_EXMEM;

 
  // EX_MEM flipflop
  EX_MEM_flipflop EXMEM(.clk(clk), .rst_n(rst_n), .WBsel_next_EXMEM(WBsel_IDEX), .MemRW_next_EXMEM(MemRW_IDEX), .regWen_next_EXMEM(regWen_IDEX),.rd_next_EXMEM(rd_IDEX) ,.Alu_out_next_EXMEM(alu_out), .rs2_next_EXMEM(read_data_2_IDEX), .pc_next_EXMEM(pc_IDEX),  
                        .rd_EXMEM(rd_EXMEM), .MemRW_EXMEM(MemRW_EXMEM), .regWen_EXMEM(regWen_EXMEM), .Alu_out_EXMEM(Alu_out_EXMEM), .rs2_EXMEM(rs2_EXMEM), .pc_EXMEM(pc_EXMEM), .WBsel_EXMEM(WBsel_EXMEM));
  //I/O DMEM khoi Dmem do dai bo nho la 32bit
// va co 256 stack bo nho
//address duoc lay ra tu ket qua cua khoi ALU
//dataWrite la gia tri cua dataB tu khoi reg[]

  wire [31:0] dataR, pc_EXMEM_out, wb_in;
  DMEM DMEM (.clk(clk), .rst_n(rst_n), .dataW(rs2_EXMEM), .Addr(Alu_out_EXMEM), .MemRW(MemRW_EXMEM), .dataR(dataR));
  //DMEM_2 DMEM (.clk(clk), .rst_n(rst_n), .dataW(dataB), .Addr(alu_out[4:0]), .MemRW(MemRW), .dataR(dataR));
  // Khoi + dia chi
    pc_add4 pc_add4_WB(.pc_in(pc_EXMEM), .pc_out(pc_EXMEM_out));
  //mem la gia tri dataR tu khoi Dmem, gia tri ket qua cua ALU, gia tri PC + 4 cho cau lenh jump and link register 
// trigger WbSelect tu khoi controller de chon cho ket qua ra Write Back vao dataD
    muxW mux_W (.mem(dataR), .alu(Alu_out_EXMEM), .pc_add4(pc_EXMEM_out), .WB_sel(WBsel_EXMEM), .wb(wb_in));

//================================================Khoi MEMWB======================================================
// day

  MEM_WB_flipflop MEMWB(.clk(clk),.rst_n(rst_n), .wr_next_MEMWB(wb_in),.regWen_next_MEMWB(regWen_EXMEM) ,.rd_next_MEMWB(rd_EXMEM),  .rd_MEMWB(rd_MEMWB),  .regWen_MEMWB(regWen_MEMWB), .wr_MEMWB(wb));

//khoi controller
//instruction tu khoi IMEM
//Branch Equal, Branch Lessthan tu khoi branch compare
//PC_sel chon PC +4 hoac gia tri tu khoi ALU
//Bsel Asel de chon gia toan hang cho khoi ALU
//BrUn trigger so sanh co dau hoac khong dau
//RegWen cho phep ghi vao thanh ghi
//Cho phep doc hoa ghi vao DMEM MemRW
//imm_sel chon 8 che do cho immediate gen cho cac format cau lenh
//Alu_sel chon cac operation cho khoi ALU
//chon gia tri WriteBack ALU, PC + 4, Dmem   
  control controller (.inst(inst_ID_IF), .BrEq(BrEq), .BrLt(BrLt), .PCsel(pc_sel), 
                      .RegWen(RegWen), .BrUn(BrUn), .Bsel(B_sel), .Asel(A_sel), .MemRW(MemRW), .imm_sel(imm_sel), .Alu_sel(alu_sel), .WBsel(WBsel));
endmodule 
    
    