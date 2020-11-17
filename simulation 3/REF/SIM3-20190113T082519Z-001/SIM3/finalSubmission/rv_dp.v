// **********************************************************************
// Technion EE 044252: Digital Systems and Computer Structure course    *
// Simple Multicycle RISC-V model                                       *
// ==============================                                       *
// Data path                                                            *
// **********************************************************************
 module rv_dp
    #(parameter
        DPWIDTH = 32,
        RFSIZE  = 32
    )
 (

     // Memory interface
     output wire [DPWIDTH-1:0] imem_addr,
     output wire [DPWIDTH-1:0] dmem_addr,
     output wire [DPWIDTH-1:0] dmem_dataout,
     input wire [DPWIDTH-1:0] dmem_datain,
     input wire [DPWIDTH-1:0] imem_datain,

     // Interface with control logic
     output wire [DPWIDTH-1:0] instr,
     output wire zero,
     input wire pcsourse,
     input wire pcwrite,
     input wire pccen,
     input wire irwrite,
     input wire [1:0] wbsel,
     input wire regwen,
     input wire [1:0] immsel,
     input wire asel,
     input wire bsel,
     input wire [3:0] alusel,
     input wire mdrwrite,
     
     // Clock and reset
     input wire clk,
     input wire rst,
	 
	 // Mul extensions
	input wire [1:0] Ma_sel,
	input wire [1:0] Mb_sel,
	input wire [4:0] Mshift_val,
	input wire Mupd_prod,
	input wire Mclr_prod
 );
  // Stage registers
 reg [DPWIDTH-1:0] pc, pcc, ir, a, b, aluout, mdr, mulout_reg;
 //our increment : internal wire
// wire [DPWIDTH-1:0] mulout;

 
  // Design parameters
 `include "params.inc"
 

 // Fetch
 assign imem_addr = pc;

 // PC
 // ==
 always @(posedge clk or posedge rst)
     if (rst)
         pc     <= 0;
     else if (pcwrite)
         pc     <= (pcsourse == PC_ALU) ? aluout : pc + 4;
 
 // PCC
 // ===
 always @(posedge clk or posedge rst)
     if (rst)
         pcc    <= 0;
     else if (pccen)
         pcc    <= pc;
 
 // IR
 // ==
 always @(posedge clk or posedge rst)
     if (rst)
         ir     <= 0;
     else if (irwrite)
         ir     <= imem_datain;
 assign instr = ir;
 
 // Register file inputs
 // ====================
 reg [DPWIDTH-1:0] datad;
 always @(*)
    case (wbsel)
        WB_MDR:     datad = mdr;
        WB_ALUOUT:  datad = aluout;
        WB_PC:      datad = pc;
		WB_MUL_RES:	datad = mulout_reg;
        default:    datad = pc;
    endcase
 wire [4:0] addra = ir[19:15];
 wire [4:0] addrb = ir[24:20];
 wire [4:0] addrd = ir[11:7];

 
 // Register File
 // =============
 reg [DPWIDTH-1:0] rf [RFSIZE-1:1];

 always @(posedge clk or posedge rst)
     if (regwen && (addrd != 0)) // X0 is constant 0
         rf[addrd]    <= datad;

 always @(posedge clk or posedge rst)
     if (rst)
     begin
         a      <= 0;
         b      <= 0;
     end
     else
     begin
         a      <= (addra == 0) ? 0 : rf[addra];
         b      <= (addrb == 0) ? 0 : rf[addrb];
     end
	 
 //MULW
 //====
 //internal variables 
	reg [7:0] choosen_a;
	reg [7:0] choosen_b;
	reg [15:0] mult_res;
	reg [31:0] shift_res;
	reg [DPWIDTH-1:0] product;
 //the calculations
 always @(posedge clk)
 begin
	if(Mupd_prod==1'b1)
	begin
		//mux 
		case(Ma_sel) 
			2'b00: choosen_a=a[7:0];
			2'b01: choosen_a=a[15:8];
			2'b10: choosen_a=a[23:16];
			2'b11: choosen_a=a[31:24];
		endcase

		case(Mb_sel) 
			2'b00: choosen_b=b[7:0];
			2'b01: choosen_b=b[15:8];
			2'b10: choosen_b=b[23:16];
			2'b11: choosen_b=b[31:24];
		endcase
		
		mult_res=choosen_a*choosen_b;

		case(Mshift_val)
			5'd0: shift_res=mult_res;
			5'd8: shift_res=mult_res<<8;
			5'd16: shift_res=mult_res<<16;
			5'd24: shift_res=mult_res<<24;
		endcase
		
		product=shift_res+product;
		if(Mclr_prod==1'b1)
			product=32'd0;
	end
	else 
		product=32'd0;
 end
 //reset
 always @(posedge rst)
 begin 
	choosen_a<=8'd0;
	choosen_b<=8'd0;
	mult_res<=16'd0;
	shift_res<=32'd0;
	product<=32'd0;
 end
 //updating mulout_reg
 always @(posedge clk or posedge rst)
     if (rst)
         mulout_reg     <= 0;
     else
         if (Mupd_prod == 1'b1) mulout_reg     <= product;	
	 
 // ALU
 // ===
 
 // Immediate selector
 reg [DPWIDTH-1:0] imm;
 always @(*)
 begin
     case(immsel)
         IMM_J: imm = {{12{ir[31]}},ir[19:12],ir[20],ir[30:21],1'b0};
         IMM_B: imm = {{20{ir[31]}},ir[7],ir[30:25],ir[11:8],1'b0};
         IMM_S: imm = {{21{ir[31]}},ir[30:25],ir[11:7]};
         IMM_L: imm = {{21{ir[31]}},ir[30:20]};
     endcase
 end

 
 // ALU input A
 wire [DPWIDTH-1:0] alu_a = (asel == ALUA_REG) ? a : pcc;

 // ALU input B
 wire [DPWIDTH-1:0] alu_b = (bsel == ALUB_REG) ? b : imm;

 // For signed comparison, cast to integer. reg is by default unsigned
 integer alu_as;
 always @(*) alu_as = alu_a;
 integer alu_bs;
 always @(*) alu_bs = alu_b;
 
 // The ALU
 reg [DPWIDTH-1:0] alu_result;
 always @(*)
     case (alusel)
         ALU_ADD: alu_result = alu_a + alu_b;
         ALU_SUB: alu_result = alu_a - alu_b;
         ALU_SLL: alu_result = alu_a << alu_b;
         ALU_SLT: alu_result = (alu_as < alu_bs) ? 1 : 0;
         ALU_SLTU:alu_result = (alu_a < alu_b) ? 1 : 0;
         ALU_XOR: alu_result = alu_a ^ alu_b;
         ALU_SRL: alu_result = alu_a >> alu_b;
         ALU_SRA: alu_result = alu_a >>> alu_b;
         ALU_OR : alu_result = alu_a | alu_b;
         ALU_AND: alu_result = alu_a & alu_b;
         default: alu_result = alu_a + alu_b;
     endcase

 assign zero = (alu_result == 0);

 always @(posedge clk or posedge rst)
     if (rst)
         aluout     <= 0;
     else
         aluout     <= alu_result;


 // Memory
 // ======
 assign dmem_addr = aluout;
 assign dmem_dataout = b;

 always @(posedge clk or posedge rst)
     if (rst)
         mdr    <= 0;
     else if (mdrwrite)
         mdr    <= dmem_datain;

endmodule


