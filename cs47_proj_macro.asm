#Farokh Confectioner
#Vidya Rangasayee
#CS47-01

# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#


#Extracts the bit located at $pos in the 
#number $reg. This extracted bit is then
#stored in $dest.
.macro extractN($dest, $reg, $pos)
	sw $t9, ($sp) 			#Saves register $t9 in memory.
	addi $t9, $reg, 0
	srlv $t9, $t9, $pos
	andi $dest, $t9, 1
	lw $t9, ($sp) 			#Restores register $t9 from memory. 
	.end_macro

#Places a bit, $reg2, into the position, $pos,
#of $reg1. The result is saved in register $dest.
.macro setN($dest, $reg1, $reg2, $pos)
	sw $t9, ($sp) 			#Saves register $t9 in memory.
	add $t9, $zero, $reg2
	sllv $t9, $t9, $pos
	or $dest, $t9, $reg1
	lw $t9, ($sp)			#Restores register $t9 from memory.
	.end_macro

#Takes the two's complement of $reg1 and 
#stores the result back into $reg1. 
.macro twos_complement($reg1)	
	sw $t8, ($sp)			#Saves register $t8 in memory.
	not $t8, $reg1			#Inverts bits.
	addi $reg1, $t8, 1		#Adds one. 
	lw $t8, ($sp)			#Restores register $t8 from memory.
	.end_macro
