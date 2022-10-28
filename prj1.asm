
# All memory structures are placed after the
# .data assembler directive
.data
arr:		.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
space:.asciiz " "
header:.asciiz "The values in our array are: "
newline:.asciiz "\n"
findtext:.asciiz "The value you searched is at location: "

# Declare main as a global function
.globl main 

# All program code is placed after the
# .text assembler directive
.text 		

# The label 'main' represents the starting point
main:
	la $a0, arr	# $a0 based address of array
	li $a1, 6	# $a1 how many numbers are generated? change the value to test your program
	li $a2, 5 # Finding a specific number in the array
	jal generate
	jal print_vals
	jal find
	add $s7, $zero, $v0 # Store our return value in saved register
	la $a0, newline # start of setup new line
	li $v0, 4 
	syscall
	la $a0, findtext # start of setup findtext
	li $v0, 4
	syscall
	add $a0, $zero, $s7 # Display index value
	li $v0, 1
	syscall
	li $v0, 10 # exit program
	syscall

	
	print_vals:
		addi $t0, $zero, 0
		la $t1, arr
		la $a0, header
		li $v0, 4
		syscall
		j f_loop
		f_loop:
			bge, $t0, $a1, end
			lw $t2, 0($t1)
			li $v0, 1
			add $a0, $zero, $t2
			syscall
			la $a0, space
			li $v0, 4
			syscall
			addi $t0, $t0, 1
			addi $t1, $t1, 4
			j f_loop
		end:
			jr $ra

	#Write your code here
	#You must print (show) the numbers generated after the function call!


generate:
	#Write your code here

	addi $sp, $sp, -8 #Create a stack to retain address of array and total numbers generated
	sw $ra, 4($sp)
	sw $a1, 0($sp) #Storing number of values generated
	# j While_Loop


	# While_Loop:

	la $t3, arr # Load base address of array
	lw $t2, 0($sp) #Total number of values to generate
	addi $t4, $zero, 0 #Our starting index of 0
	j For_loop
		For_loop:
			#Beginning of code to generate a value between 0 and 9
			li $v0, 42 #Syscode to create 
			add $a0, $zero, 5 # 5 is just an id? That's what the documenation said
			add $a1, $zero, 10 # High vlaue of our randomly generated number cannont be 10 by less than 10
			syscall
			#If statements
			bge $t4, $t2, end_loop #Test $t4 <= $t2 (total numbers to generate)
			lw $t5, 0($t3) #Load value from arr[0] position
			la $t7, arr # Loads base address of array
			addi $t8, $zero, 0
			jal val_check
			beq $t5, $zero, else

		val_check:
			lw $t6, 0($t7) # Loads value at array starting at the beginning
			bge $t8, $t2, success #branches if it gets all the way through array return to after jal val_check
			beq $t6, $a0, retry # If check fails it gets pushed back to for_loop
			addi $t8, $t8, 1 # increments iterator by 1
			addi $t7, $t7, 4
			j val_check # Continues checking
		success:
			jr $ra
		else:
			sw $a0, 0($t3)
			addi $t3, $t3, 4
			addi $t4, $t4, 1
			
			# FOR TESTING VALUES #
			#  li $v0, 1
			# add $a0, $zero, $t6
			#  syscall
			# FOR TESTING VALUES #
			j For_loop

		retry:
			j For_loop
		end_loop:  
			lw $ra, 4($sp)
			lw $a1, 0($sp)
			jr $ra


find:
	addi $sp, $sp, -4 # Create area in stack for $ra
	sw $ra, 0($sp) # Store #ra
	addi $t0, $zero, 0 # counter for loop
	la $t1, arr # loading base address of array
	j f_loop_find # jump to loop
	f_loop_find: 
		lw $t2, 0($t1) # load the value in array at base
		beq $t2, $a2, end_f_loop_find # If value in $t2 is the same as $a2 end the find success
		bge $t0, $a1, end_f_loop_fail # If no value is found end the loop fail
		addi $t0, $t0, 1
		addi $t1, $t1, 4
		j f_loop_find
	end_f_loop_find:
		lw $ra, 0($sp) # Load the return address
		add $v0, $zero, $t0 # Load the index of the location into $v0
		jr $ra
	end_f_loop_fail:
		lw $ra, 0($sp) # Load the return address
		addi $v0, $zero, -1 # Load -1 to indicate no value in loop
		jr $ra
	
