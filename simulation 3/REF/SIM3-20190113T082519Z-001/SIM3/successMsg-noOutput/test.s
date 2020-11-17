.text
main:   add		t6, x0, x0
		lw		t1, 8(x0)		
		lw		t2, 12(x0)
		mul		t3, t1, t2
		sw		t3, 16(x0)
        beq		t6, x0, finish

# This shouldn't be reached
deadend: beq	t6, x0, deadend        

finish:
        lw		t4, 0(x0)
        lw		t5, 4(x0)
        sw		t5, 0xFF(t4)
        beq		t6, x0, deadend