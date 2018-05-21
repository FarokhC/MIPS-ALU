#Farokh Confectioner
#Vidya Rangasayee
#CS47-01

.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
# TBD: Complete it
	beq $a2, 43, addition 		#Checks if addition is called. 
	beq $a2, 45, subtraction 	#Checks if substraction is called.
	beq $a2, 42, multiplication	#Checks if multiply is called
	beq $a2, 47, division 		#Checks if division is called. 
	
	addition:
		add $v0, $a0, $a1	#Adds $a0 and $a1 parameters.
		j result

	subtraction:
		sub $v0, $a0, $a1 	#Subtracts $a0 with $a1.
		j result
						
	multiplication:
		mult $a0, $a1		#Multiplies $a0 and $a1 parameters. 
		mflo $v0
		mfhi $v1
		j result
	
	division:
		div $a0, $a1 		#Divides $a0 with $a1.
		mflo $v0
		mfhi $v1
		j result
	
	result:
		jr $ra
