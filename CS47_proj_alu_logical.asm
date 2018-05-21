#Farokh Confectioner
#Vidya Rangasayee
#CS47-01

.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################

au_logical:
	sw $t0, 0($sp) 		#Saving all of the registers used to prevent any 
	sw $t1, 4($sp)		#unintended effect on other pieces of code. 
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)
	sw $t6, 24($sp)
	sw $t7, 28($sp)
	sw $t8, 32($sp)
	sw $t9, 36($sp)
	sw $s0, 40($sp)
	sw $s1, 44($sp)
	
	beq $a2, 43, startAddition 		#Checks if addition is called. 
	beq $a2, 45, subtraction 		#Checks if substraction is called.
	beq $a2, 42, startMultiplication	#Checks if multiply is called
	beq $a2, 47, startDivision 		#Checks if division is called. 

startAddition:
	addi $t0, $zero, 0		#increment value I = 0
	addi $t9, $zero, 0		#t9 = carry value
	addi $v0, $zero, 0		#v0 = result value
addition:
	extractN($t1, $a0, $t0)    	#extracts the Ith bit.
	extractN($t2, $a1, $t0)   	#extracts the Ith bit. 
	
	beqz $t9, NoCarry   		#If carry is zero, skip the carry steps. 
	xor $t3, $t1, $t2    
	xor $t3, $t3, $t9  
	or $t9, $t1, $t2      
	setN($v0, $v0, $t3, $t0)    	#Sets the bit value into result, $v0.

	addi $t0, $t0, 1 		#Increment counter. 
	bne $t0, 32, addition   
	beq $t0, 32, result 
	
NoCarry:
	and $t9, $t1, $t2
	xor $t3, $t1, $t2 
	setN($v0, $v0, $t3, $t0) 	#Sets the bit value into result, $v0. 
	addi $t0, $t0, 1 		#Increments counter I.
	bne $t0, 32, addition    	#Breaks out of loop
	j result 			#Return
	
subtraction:		       
	twos_complement($a1)		#Does two's complement by inverting bits
	j startAddition			#and adding one to second operand. Then jumps  
        				#to addition.
       
startMultiplication:
	li $t0, 0			#I = 0.
	li $t1, 0			#H = 0.

	addi $t4, $zero, 31		#$t4 Holds a value of 31.
	extractN($t5, $a0, $t4)		#Gets sign value of multiplicand.
	extractN($t6, $a1, $t4)		#Gets sign value of multiplier.
	xor $v1, $t5, $t6		#Holds onto final sign bit.
	
multiplierSign:
	bgt $a0, 0, multiplicandSign	#If multiplicand is negative, do two's complement.
	twos_complement($a0)
	
multiplicandSign:
	bgt $a1, 0, multiplication 	#If multiplier is negative, do two's complement. 
	twos_complement($a1)
	
multiplication:
	extractN($t5, $a1, $zero) 	#Gets the 0th bit of the multiplier. 
	beq $t5, 0, shiftBits 		#If the 0th bit of multiplier is 0, skip adding to $v0.
	add $v0, $v0, $a0 		#Add lsb bit of $a0 to $v0.
	
shiftBits:
	sll $a0, $a0, 1 		#Shifting multiplicand left by one bit.
	srl $a1, $a1, 1			#Shifting multiplier right by one bit. 
	addi $t0, $t0, 1 		#i += 1
	blt $t0, 32, multiplication 	#Breaks out of loop. 
	bne $v1, 1, multEnd 		#Skips over two's complement if one of $a0 or $a1 is negative. 
	twos_complement($v0) 		#Takes two's complement of $v0.
	addi $v1, $v1, -2
	addi $v0, $v0, 4
	j multEnd
	
multEnd:
	sub $v0, $v0, 2
	j result 			#Return.

startDivision:
	addi $t0, $zero, 0 		#I = 0.
	addi $t1, $a0, 0 		#Quotient = Q = $a0.
	addi $t2, $a1, 0 		#Divisor = D = $a1.
	addi $s0, $zero, 0		#Setting $a0 marker to positive.
	addi $s1, $zero, 0		#Setting $a1 marker to positive.
	addi $t3, $zero, 0 		#Remainder R = 0.
	
	bgez $t1, quotGreaterZero
	addi $s0, $zero, 1 		#Sets quotient marker to negative.	
	twos_complement($t1)
	
quotGreaterZero:
	bgez $t2, Division 		#Sets remainder marker to negative.
	addi $s1, $zero, 1
	twos_complement($t2)
	
Division:
	sll $t3, $t3, 1			#Shift R left by 1.
	li $t4, 31
	extractN($t5, $t1, $t4)		#Extract 31st bit from Quotient.
	addi $t8, $zero, 0
	setN($t3, $t3, $t5, $t8)	#Setting R[0] to 31st bit of Q.
	sll $t1, $t1, 1 		#Shift quotient left by one. 
	sub $t6, $t3, $t2 		#S value.
	bltz $t6, sLessThanZero 	#Checks if $t6 is greater than 
					#or less than zero.
sNotLessThanZero:
	addi $t3, $t6, 0 
	addi $t8, $zero, 0
	addi $t9, $zero, 1
	setN($t1, $t1, $t9, $t8) 	
sLessThanZero:
	addi $t0, $t0, 1		#i = i + 1
	beq $t0, 32, divFinish
	j Division

divFinish:
	xor $t6, $s0, $s1 		
	beq $t6, 0, no2CompQ
	twos_complement($t1) 		#Reverts sign of $t1. 
	
no2CompQ:
	addi $t6, $s0, 0
	beq $t6, 0, no2CompR 
	
no2CompR:
	twos_complement($t3) 		#Reverts sign of $t3. 
	
	beq $t6, 1, noRemainderSignCheck
	twos_complement($t3) 		#Reverts sign of $t3 if necessary. 
	
noRemainderSignCheck:
	addi $v0, $t1, 0 		#Places solution to return register.
	addi $v1, $t3, 0		#Places solution to return register.
	j result 			#Return

result:
	lw $t0, 0($sp) 			#Restoring all used registers back to 
	lw $t1, 4($sp)			#the original values to prevent any 
	lw $t2, 8($sp)			#effects on other code. 
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	lw $t5, 20($sp)
	lw $t6, 24($sp)
	lw $t7, 28($sp)
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	lw $s0, 40($sp)
	lw $s1, 44($sp)
	jr $ra