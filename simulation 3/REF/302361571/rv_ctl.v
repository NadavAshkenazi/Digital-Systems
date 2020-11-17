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

     output wire [1:0] a_selw,    // Select one byte from A
     output wire  b_selw,   // Select one 2-byte word from B
     output wire  [5:0] shift_valw,// Shift value of 8-bit mult product
     output wire upd_prodw,      // Update the product register
     output wire  clr_prodw,
     

     
     // Clock and reset
     input wire clk,
     input wire rst
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
    MUL_WAIT    = 10,
    MUL_EXEC    = 11,
    MUL_WAIT2   = 12,
    JAL_EXEC    = 9;
 reg [3:0] current, next;

 // Next state sampling
 always @(posedge clk or posedge rst)
     if (rst)            current <= FETCH;
     else                current <= next;

 // Opcode + Funct3 fields define the instruction
 wire [9:0] opcode_funct3 = {instr[6:0], instr[14:12]};
 wire [6:0] opcode_func_7 = {instr[31:25]};

 // State transitions
 // ~~~~~~~~~~~~~~~~~
// MUL FSM i/o wires
reg start,reset;
reg  [1:0] a_sel;    // Select one byte from A
reg  b_sel;    // Select one 2-byte word from B
reg  [5:0] shift_val;// Shift value of 8-bit mult product
reg upd_prod;       // Update the product register
reg  clr_prod; 
wire validw;


/*
assign  a_selw = a_sel;
assign  b_selw = b_sel;
assign  shift_valw = shift_val;
assign  upd_prodw = upd_prod;
assign  clr_prodw = clr_prod;
*/

    mult32x32_fsm fs (validw,a_selw,b_selw,shift_valw,upd_prodw,clr_prodw,start,clk,reset);
 always @(*)
 begin

    case (current)
	MUL_WAIT: begin

		next = MUL_EXEC;
		
	end
	MUL_WAIT: begin

		next = MUL_EXEC;
		
	end
	MUL_EXEC: begin
		if(validw ==  0) begin 
			start = 0;
			next = MUL_EXEC;
		end
		else if (validw == 1) begin
			wbsel = WB_MUL; 
			regwen      = 1'b1;
			
			next = RTYPE_WB; // state 7 in the standard controller 
		end
	end
        FETCH: begin
            
	    //if(opcode_func_7 == MUL_f_7 && opcode_funct3 == MUL) begin
		reset = 1;
		start = 1'b1;
		next = DECODE;
	    //end
	end
        DECODE: begin
	    reset = 0;
	    if(opcode_func_7 == MUL_f_7 && opcode_funct3 == MUL) begin
		
		//start = 1'b1;
		next = MUL_EXEC;
	    end
	    else begin
            casex (opcode_funct3)
                LW:     next = LSW_ADDR;
                SW:     next = LSW_ADDR;
                ALU:    next = RTYPE_ALU;
                BEQ:    next = BEQ_EXEC;
                JAL:    next = JAL_EXEC;
                // For unimplemented instructions do nothing
                default:next = FETCH; 
            endcase
	    end
        end
        LSW_ADDR: begin
            casex (opcode_funct3)
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
	    //start = 0;
	
	    reset = 1;
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
            immsel      = (opcode_funct3 == LW) ? IMM_L : IMM_S;
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
	   if(opcode_func_7 == MUL_f_7 && opcode_funct3 == MUL) begin
		
		wbsel = WB_MUL;
		regwen      = 1'b1;

	    end
	    else begin
            wbsel       = WB_ALUOUT;
            regwen      = 1'b1;
	    end
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
    endcase
 end

endmodule
