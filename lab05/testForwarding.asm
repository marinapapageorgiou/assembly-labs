# ----------------------------------------------------------------------------------------
# testForwarding.asm 
#  Verify correctness of forwarding logic of the 5-stage pipelined MIPS processor
#    used in MYY505
# At exit, v1 will be 0 when all tests pass. Any other number indicates a mistake in pipeline control
# ----------------------------------------------------------------------------------------

.data
storage:
    .word 1							# 0(a0) = 1
    .word 10						# 4(a0) = 10
    .word 11						# 8(a0) = 11

.text
# ----------------------------------------------------------------------------------------
# prepare register values.
# ----------------------------------------------------------------------------------------
#  DO NOT USE li as it breaks into 2 instructions and requires forwarding $at between them.
#  I use la here, but I should have assigned the address to $a0 differently

	la   $a0, storage
    addi $s0, $zero, 0				# $s0 = 0
    addi $s1, $zero, 1				# $s1 = 1
    addi $s2, $zero, 2				# $s2 = 2
    addi $s3, $zero, 3				# $s3 = 3
    
# ----------------------------------------------------------------------------------------
# SKEPTIKO:
# stin ekfonisi uparxoun 3 kodikes
# gia kathe kodika mporo na vro 5 test cases
# 2 TC gia to ID -- 2 TC gia to EXE --1 TC gia to MEM

############################

# Gia ton kodika(1st):	
# add $t0, $t1, $t2 				# produce new $t0 value
# beq $t0, $t3, label 				# stall 1 cycle and then forward new $t0 value to this instruction

############################

# Gia ton kodika(2ed):
# add $t0, $t1, $t2 				# produce new $t0 value
# add $t3, $t0, $t4 				# forward new $t0 value to this instruction

############################

# Gia ton kodika(3ed):
# add $t0, $t1, $t2 				# produce new $t0 value
# add $s0, $s1, $s2 				# independent instruction w.r.t. $t0
# add $t3, $t0, $t4 				# forward new $t0 value to this instruction

############################
# PAIRS: 1A-1B			
test1A:
	addi $v1, $zero, 1				# number of occations

    add  $t8, $s1, $s2				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]			
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $t8, $s3, test1B 			# difference #1B
    								# Check if $t8 (=3) is forwarded to $s3 (=3)

test1B:					
	addi $v1, $zero, 2				# number of occations
	
    add  $t8, $s1, $s2				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s3, $t8, test2A 			# difference #1A
    								# Check if $s3 (=3) is forwarded to $t8 (=3) 
    
# PAIRS: 2A-2B
test2A:					
	addi $v1, $zero, 3				# number of occations
	    
    add  $t8, $s1, $s2 				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]
    add  $s4, $t8, $zero  			# difference #2B
    								# $s4 should be == $t8 (==3), unless $zero gets forwarded here from the above instruction
       								# added 2 dummy instructions here to avoid testing if $s4 gets forwarded to branch
       								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction   				-- proairetiko
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test2B  			# Check if $s4 (=3) is forwarded to $t8 (=3)
    j    exit               		# exit with code 1 in v1, if zero was forwarded


test2B:				
	addi $v1, $zero, 4				# number of occations
	
    add  $t8, $s1, $s2				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]
    add  $s4, $zero, $t8 			# difference #2A
    								# $s4 should be == $t8 (==3), unless $zero gets forwarded here from the above instruction  (=3)
       								# added 2 dummy instructions here to avoid testing if $s4 gets forwarded to branch
       								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction   				--  proairetiko
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test3A			# Check if $s4 (=3) is forwarded to $t8 (=3)
    j    exit						# exit with code 1 in v1, if zero was forwarded
    
# PAIRS: 3A-3B
test3A:					
	addi $v1, $zero, 5				# number of occations

    add  $t8, $s1, $s2				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]
    add  $t1, $s1, $s2 				# dummy instruction 
    add  $s4, $t8, $zero  			# difference #3B
    								# This instruction checks $t8 forwarding ($s4 = 3)
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test3B			# Check if $s4 (=3) is forwarded to $t8 (=3)
    j    exit						# exit with code 1 in v1, if zero was forwarded


test3B:					
	addi $v1, $zero, 6				# number of occations
	
    add  $t8, $s1, $s2				# give new value at $t8 (=3)		-- [$s1 = 1 and $s2 = 2]
    add  $t1, $s1, $s2  			# dummy instruction
    add  $s4, $zero, $t8 			# difference #3A
    								# This instruction checks $zero forwarding
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2 				# dummy instruction
    beq  $s4, $t8, test1C			# Check if $s4 (=3) is forwarded to $t8 (=3)
    j    exit						# exit with code 1 in v1, if zero was forwarded
    
   
# PAIRS: 1C-1D
test1C:  				
    addi $v1, $zero, 7
    
    lw   $t8, 0($a0)				# The loaded value is 1 (0($a0) = 1)
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $t8, $s1, test1D			# difference #1D
    								# Check if $t8 (=1) is forwarded to $s1 (=1) 
    j    exit						# exit with code 1 in v1, if zero was forwarded


test1D: 				
    addi $v1, $zero, 8
    
    lw   $t8, 0($a0)				# The loaded value is 1 (0($a0) = 1)
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s1, $t8, test2C			# difference #1C
    								# Check if $s1 (=1) is forwarded to $t8 (=1)
    j    exit 						# exit with code 1 in v1, if zero was forwarded
    

# PAIRS: 2C-2D       
test2C:					
    addi $v1, $zero, 9
    
    lw   $t8, 4($a0)      			# The loaded value is 10 (4($a0) = 10)
    
    add  $s4, $zero, $t8  			# difference #2D
    								# check if $zero is wrongly forwarded here
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8,	test2D			# Check if $s4 (=10) is forwarded to $t8 (=10)
    j    exit						# exit with code 1 in v1, if zero was forwarded


test2D:					
    addi $v1, $zero, 10
    
    lw   $t8, 4($a0)       			# The loaded value is 10 (4($a0) = 10)
    
    add  $s4, $t8, $zero  			# difference #2C
    								# check if $t8 is wrongly forwarded here
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test3C			# Check if $s4 (=10) is forwarded to $t8 (=10)
    j    exit						# exit with code 1 in v1, if zero was forwarded
    

# PAIRS: 3C-3D        
test3C:  				
    addi $v1, $zero, 11
    
    lw   $t8, 8($a0)      			# The loaded value is 11 (8($a0) = 11)
    								# oti offeset(0,4,8) kai na evaza tha itan sosto
    add  $t1, $s1, $s2  			# dummy instruction
    add  $s4, $zero, $t8  			# difference #3D
    								# check if $zero is wrongly forwarded here
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test3D			# Check if $s4 (=11) is forwarded to $t8 (=11)
    j    exit						# exit with code 1 in v1, if zero was forwarded


test3D:  				
    addi $v1, $zero, 12
    
    lw   $t8, 8($a0)       			# The loaded value is 11 (8($a0) = 11)
    								# oti offeset(0,4,8) kai na evaza tha itan sosto
    add  $t1, $s1, $s2    			# dummy instruction
    add  $s4, $t8, $zero  			# difference #3C
    								# check if $t8 is wrongly forwarded here
    								# proothisi
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $s4, $t8, test1E			# Check if $s4 (=11) is forwarded to $t8 (=11)
    j    exit						# exit with code 1 in v1, if zero was forwarded
    

# PAIRS: 1E-2E-3E
test1E:					
	addi $v1, $zero, 13				# number of occations
	
    lw   $t8, 0($a0)
    sw   $t8, 4($a0)  				# this should store 10 into memory (prev value @mem = 1)
    lw   $t0, 4($a0)  				# load back the value from memory, to check it
    add  $t1, $s1, $s2  			# dummy instruction
    add  $t1, $s1, $s2  			# dummy instruction
    beq  $t0, $t8, pass 			# Check if $t0 (=10) is forwarded to $t8 (=10)	
    j    exit						# exit with code 1 in v1, if zero was forwarded


#test2E:				#####WRONG
#	addi $v1, $zero, 14				# number of occations
	
#    lw   $t8, 4($a0)
#    sw   $t8, 8($a0)  				# this should store 11 into memory (prev value @mem = 1)
#    lw   $t0, 8($a0)  				# load back the value from memory, to check it
#    add  $t1, $s1, $s2  			# dummy instruction
#    add  $t1, $s1, $s2  			# dummy instruction
#    beq  $t0, $t8, pass 			# Check if $t0 (=11) is forwarded to $t8 (=11)
#    j    exit
    
    
#test3E:				#####WRONG
#	addi $v1, $zero, 15				# number of occations
	
#    lw   $t8, 4($a0)
#    sw   $t8, 8($a0)  				# this should store 11 into memory (prev value @mem = 1)
#    lw   $t0, 8($a0)  				# load back the value from memory, to check it
#    add  $t1, $s1, $s2  			# dummy instruction
#    add  $t1, $s1, $s2  			# dummy instruction
#    beq  $t0, $t8, pass 			# Check if $t0 (=11) is forwarded to $t8 (=11)
#    j    exit


############################
pass:
    add  $v1, $zero, $zero  		# previous write to zero is too far to affect this

exit:  								# Check $v1. 0 means all tests pass, any other value is a unique error
    addiu $v0, $zero, 10    		# system service 10 is exit
    syscall
