# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
		
main:   # Load data from memory
		la      t3, a

        sw		s10, 0(t3)
        lw      t3, 0(t3)
        la      t4, b
     	sw		s11, 0(t4)
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
        
####################
# Start of your code


# Use the code below for 8X8 multiplication
	  #	beq			t4, x0, finish
        srli		t0, t0, 16
        and			s0, t0, t3
        mul			t6, s0, t4
        slli		t0, t0, 8
        and			s0, t0, t3
       # beq 		s0, x0, finish
        mul			s1, t4, s0
        add			t6, t6, s1
        

# End of your code
####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


