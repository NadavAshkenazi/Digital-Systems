// **********************************************************************
// Technion EE 044252: Digital Systems and Computer Structure course    *
// Simple Multicycle RISC-V model                                       *
// ==============================                                       *
// Control plane                                                        *
// **********************************************************************
 module rv_ctl
 (

     // Output to memory
     output reg memrw,

     // Interface with datapath
     input wire [31:0] instr,
     input wire zero,
     output reg pcsourse,
     output reg pcwrite,
     output reg pccen,
     output reg irwrite,
     output reg [1:0] wbsel,
     output reg regwen,
     output reg [1:0] immsel,
     output reg asel,
     output reg bsel,
     output reg [3:0] alusel,
     output reg mdrwrite,
     
     // Clock and reset
     input wire clk,
     input wire rst,
	 
	 // MUL increments
	 output reg [1:0] Ma_sel,
	 output reg [1:0] Mb_sel,
	 output reg [4:0] Mshift_val,
	 output reg Mupd_reg,
	 output reg Mclr_reg
	 //output reg Mdone_reg //
 );
 
 // Design parameters
 `include "params.inc"

 // =========================================================
 // The state machine
 // =================

 // State declarations
 localparam
    FETCH       = 0,
    DECODE      = 1,
    LSW_ADDR    = 2,
    LW_MEM      = 3,
    LW_WB       = 4,
    SW_MEM      = 5,
    RTYPE_ALU   = 6,
    RTYPE_WB    = 7,
    BEQ_EXEC    = 8,
    JAL_EXEC    = 9,
	MUL1		= 10,
	MUL2		= 11,
	MUL3		= 12,
	MUL4		= 13,
	MUL5		= 14,
	MUL6		= 15,
	MUL7		= 16,
	MUL8		= 17,
	MUL9		= 18,
	MUL10		= 19,
	MUL_WB      = 20;
	

 reg [3:0] current, next;

 // Next state sampling
 always @(posedge clk or posedge rst)
     if (rst)            current <= FETCH;
     else                current <= next;

 // Opcode + Funct3 fields define the instruction
  wire [9:0] opcode_funct3_funct7 = {instr[6:0], instr[14:12]}; //with FUNC7
 //wire [10:0] opcode_funct3_funct7 = {instr[6:0], instr[14:12], instr[25]}; //with FUNC7
 always @(*)
	$display("opcode_funct3: %b, instr[25]: %b", opcode_funct3_funct7, instr[25]);
 //wire [10:0] opcode_funct3_funct7 = 11'b0110011_000_1;
 

 // State transitions
 // ~~~~~~~~~~~~~~~~~
 always @(*)
 begin
    case (current)
        FETCH:
            next = DECODE;
        DECODE: begin
            casex (opcode_funct3_funct7)
                LW:     next = LSW_ADDR;
                SW:     next = LSW_ADDR;
				//MULW:	next = MUL1;
                ALU:    if (instr[25] == 0)
							next = RTYPE_ALU;
						else
							next = MUL1;
                BEQ:    next = BEQ_EXEC;
                JAL:    next = JAL_EXEC;

                // For unimplemented instructions do nothing
                default:next = FETCH; 
            endcase
        end
        LSW_ADDR: begin
            casex (opcode_funct3_funct7)
                LW:     next = LW_MEM;
                SW:     next = SW_MEM;
                // This is never reached
                default:next = SW_MEM;
            endcase
        end
        LW_MEM:
            next = LW_WB;
        LW_WB:
            next = FETCH;
        SW_MEM:
            next = FETCH;
        RTYPE_ALU:
            next = RTYPE_WB;
        RTYPE_WB:
            next = FETCH;
        BEQ_EXEC:
            next = FETCH;
        JAL_EXEC:
            next = FETCH;
		MUL1:	
			next = MUL2;	
		MUL2:	
			next = MUL3;
		MUL3:	
			next = MUL4;
		MUL4:	
			next = MUL5;
		MUL5:	
			next = MUL6;
		MUL6:	
			next = MUL7;
		MUL7:	
			next = MUL8;
		MUL8:	
			next = MUL9;
		MUL9:	
			next = MUL10;
		MUL10:	
			next = MUL_WB;
		MUL_WB:
			next = FETCH;
        default: // Should never reach this
            next = FETCH;
    endcase
 end

 // State Machine Outputs
 // ~~~~~~~~~~~~~~~~~~~~~
 
 always @(*)
 begin
     // Default values of all the controls to avoid latches
    pcsourse = PC_INC;
    pcwrite = 1'b0;
    pccen = 1'b0;
    irwrite = 1'b0;
    wbsel = WB_PC;
    regwen = 1'b0;
    immsel = IMM_B;
    asel = ALUA_REG;
    bsel = ALUB_REG;
    alusel = ALU_ADD;
    mdrwrite = 1'b0;
    memrw = 1'b0;
    case (current)
        FETCH:
        begin
            pccen       = 1'b1;
            pcwrite     = 1'b1;
            irwrite     = 1'b1;
            pcsourse    = PC_INC;
        end
        DECODE: begin
            immsel      = IMM_B;
            asel        = ALUA_PCC;
            bsel        = ALUB_IMM;
            alusel      = ALU_ADD;
        end
        LSW_ADDR: begin
            immsel      = (opcode_funct3_funct7 == LW) ? IMM_L : IMM_S;
            asel        = ALUA_REG;
            bsel        = ALUB_IMM;
            alusel      = ALU_ADD;
        end
        LW_MEM:
            mdrwrite    = 1'b1;
        LW_WB: begin
            wbsel       = WB_MDR;
            regwen      = 1'b1;
        end
        SW_MEM:
            memrw       = 1'b1;
        RTYPE_ALU: begin
            asel        = ALUA_REG;
            bsel        = ALUB_REG;
            alusel      = {instr[14:12],instr[30]}; // Funct3 and INST[30]
        end
        RTYPE_WB: begin
            wbsel       = WB_ALUOUT;
            regwen      = 1'b1;
        end
        BEQ_EXEC: begin
            asel        = ALUA_REG;
            bsel        = ALUB_REG;
            alusel      = ALU_SUB;
            pcsourse    = PC_ALU;
            if (zero)
                pcwrite = 1'b1;
        end
        JAL_EXEC: begin
            asel        = ALUA_PCC;
            bsel        = ALUB_IMM;
            alusel      = ALU_ADD;
            pcsourse    = PC_ALU;
            pcwrite     = 1'b1;
            regwen      = 1'b1;
            wbsel       = WB_PC;
        end
		MUL1: begin
			  Ma_sel	= 2'b00;
			  Mb_sel	= 2'b00;
			  Mshift_val= 6'd0; //0
			  Mupd_reg	= 1'b1;
			  Mclr_reg	= 1'b0;
			  //Mdone_reg = 1'b0;
		end 
		MUL2: begin
			  Ma_sel	= 2'b00;
			  Mb_sel	= 2'b01;
			  Mshift_val= 6'd8; //8
			  Mupd_reg	= 1'b1;
			  Mclr_reg	= 1'b0;
			  //Mdone_reg	= 1'b0;
		end
		MUL3: begin
			 Ma_sel		= 2'b00;
			 Mb_sel		= 2'b10;
			 Mshift_val	= 6'd16; //16
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			// Mdone_reg	= 1'b0;
		end
		MUL4: begin
			 Ma_sel		= 2'b00;
			 Mb_sel		= 2'b11;
			 Mshift_val	= 6'd24; //24
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			 //Mdone_reg	= 1'b0;
		end			
		MUL5: begin
			 Ma_sel		= 2'b01;
			 Mb_sel		= 2'b00;
			 Mshift_val	= 6'd8; //8
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			 //Mdone_reg	= 1'b0;
		end
		MUL6: begin
			 Ma_sel		= 2'b01;
			 Mb_sel		= 2'b01;
			 Mshift_val	= 6'd16; //16
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			 //Mdone_reg	= 1'b0;
		end
		MUL7: begin
			 Ma_sel		= 2'b01;
			 Mb_sel		= 2'b10;
			 Mshift_val	= 6'd24; //24
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			//Mdone_reg	= 1'b0;
		end
		MUL8: begin
			 Ma_sel		= 2'b10;
			 Mb_sel		= 2'b00;
			 Mshift_val	= 6'd16; //16
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			// Mdone_reg	= 1'b0;
		end
		MUL9: begin
			 Ma_sel		= 2'b10;
			 Mb_sel		= 2'b01;
			 Mshift_val	= 6'd24; //24
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			// Mdone_reg	= 1'b0;
		end
		MUL10: begin
			 Ma_sel		= 2'b11;
			 Mb_sel		= 2'b00;
			 Mshift_val	= 6'd24; //24
			 Mupd_reg	= 1'b1;
			 Mclr_reg	= 1'b0;
			 //Mdone_reg	= 1'b0;
		end
		MUL_WB: begin
			wbsel       = WB_MUL_RES;
            regwen      = 1'b1;
		end
    endcase
 end

endmodule
