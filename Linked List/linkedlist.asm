.data
 promptInt: .asciz "Insert an int: "
 promptForPrint: .asciz "Enter a number (all elements of the list greater than that number will be printed): "
 newLn: .asciz "\n"
 separator: .asciz ","
	
.text
# -------------- Main program --------------
main:
	addi t0, x0, 1 # used by the input loop's condition
	# initialize list with empty node
	# allocate 8 bytes in heap memory
	li a7, 9
	addi a0, x0, 8
	ecall
	# data=0 & nxtPtr=0
	sw x0, 0(a0)
	sw x0, 4(a0)
	# s0 == head of list
	# s1 == end of least
	# s0->emptyNode & s1->emptyNode
	add s0, a0, x0
	add s1, a0, x0
inputLoop: 
	# print input prompt
	li a7, 4
	la a0, promptInt
	ecall
	jal ra, read_int # read an int to store into the list
	# a0 contains the int returned by the function
	blt a0, t0, traversal # input was <= 0
	add t1, a0, x0 # store the returned int into a tmp register
	jal ra, node_alloc # allocate node mem
	# node->data = input
	sw t1, 0(a0)
	# node->nxtPtr = 0
	sw x0, 4(a0)
	# prev->nxtPtr = node
	sw a0, 4(s1)
	# s1->node
	add s1, a0, x0
	j inputLoop # int another int
traversal:
	# break line
	li a7, 4
	la a0, newLn
	ecall
	# print prompt for inpt
	li a7, 4
	la a0, promptForPrint
	ecall
	# read int
	li a7, 5
	ecall
	# store int in s1
	add s1, a0, x0
	# if int < 0
	blt s1, x0, error
	# else: init s2 with the first node of the list (traversal pointer)
	add s2, s0, x0
	# setup arguments for search_list()
	add a0, s2, x0 # pass the traversal pointer
	add a1, s1, x0 # pass the integer to use for comparison
	jal ra, search_list
	j traversal
error:
	# exit the program
	li a7, 10
	ecall
	
# -------------- Functions --------------
read_int: # reads an int and returns it into a0
	li a7, 5
	ecall
	jalr x0, ra, 0

node_alloc: # allocates 8 bytes in memory for a new node and returns the address in a0
	li a7, 9 #set break
	addi a0, x0, 8
	ecall
	jalr x0, ra, 0
	
search_list: # prints any node whose data is greater than the given int
	   # Params: a0: traversal pointer , a1: the value to look for
	# use the stack to preserve the traversal pointer's value & the return address of our caller
	addi sp, sp, -8 # allocate 8 bytes on the stack
	sw ra, 4(sp) # save ra into the first word
	sw a0, 0(sp) # save traversal pointer into the second word	
	# setup arguments for print_node()
	add a0, a0, x0 # pass the address of the current node
	# the int to use for comparison is already in a1
	jal ra, print_node
	# restore the value of s2 from the stack
	lw ra, 4(sp) # restore the original ra
	lw a0, 0(sp) # restore the traversal pointer (first argument of search_list)
	addi sp, sp, 8 # deallocate the 8 bytes
	# check if there is another node to traverse
	lw t0, 4(a0) # t0 = node->nxtPtr
	beq t0, x0, exit_srchlst # nxtPtr == 0
	# else go to the next node and repeat
	add a0, t0, x0
	j search_list
exit_srchlst:
	jalr x0, ra, 0
		
print_node: # if the data of the given node (a0) is greater than the given int (a1), prints the node data
	lw t0, 0(a0) # t0 = node->data
	bge a1, t0, exit_prnd # if data < given int, don't print
	# else print data
	li a7, 1
	add a0, x0, t0
	ecall
	# print separator
	li a7, 4
	la a0, separator
	ecall
exit_prnd:
	jalr x0, ra, 0