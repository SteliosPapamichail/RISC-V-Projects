.data
 i: .word 5
 j: .word 10
 arr: .zero 20 # a b c d e

.text

main:
	# store addr of arr into s0
	la s0, arr

	# init vars
	addi t0, x0, 1
	sw t0, 0(s0) # a = 1
	addi t0, x0, 2
	sw t0, 4(s0) # b = 2
	addi t0, x0, 3
	sw t0, 8(s0) # c = 3
	addi t0, x0, 4
	sw t0, 12(s0) # d = 4
	addi t0, x0, 5
	sw t0, 16(s0) # e = 5

	# c statements to assembly
	lw t0, 0(s0)
	lw t1, 4(s0)
	lw t2, 8(s0)
	add s1, t0, t1
	sw s1, 12(s0)
	add s2, t0, t2
	sw s2, 16(s0)
