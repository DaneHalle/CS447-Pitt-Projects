#Dane Halle (dmh148)

# Key states
.globl leftPressed
.globl rightPressed
.globl upPressed
.globl downPressed
.globl actionPressed

# Determines the key states
.globl handleInput
.globl clearInput

.data

# Key states

leftPressed:		.word	0
rightPressed:		.word	0
upPressed:		.word	0
downPressed:		.word	0
actionPressed:		.word	0

.text
	
# bool handleInput()
#   Handles any button input.
# returns: v0: 1 when the game should end.
handleInput:
	push	ra
	
	# Get the key state memory
	li	t0, 0xffff0004
	lw	t1, (t0)
	
	# Check for key states
	and	t2, t1, 0x1
	lw	t3, upPressed
	or	t2, t2, t3
	sw	t2, upPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	lw	t3, downPressed
	or	t2, t2, t3
	sw	t2, downPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	lw	t3, leftPressed
	or	t2, t2, t3
	sw	t2, leftPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	lw	t3, rightPressed
	or	t2, t2, t3
	sw	t2, rightPressed
	
	srl	t1, t1, 1
	and	t2, t1, 0x1
	lw	t3, actionPressed
	or	t2, t2, t3
	sw	t2, actionPressed
	
	li	v0, 0
	
	pop	ra
	jr	ra

# void clearInput()
#   Resets the button states. They will be set if the key is still pressed
#   upon the next call to handleInput.
clearInput:
	sw	zero, upPressed
	sw	zero, leftPressed
	sw	zero, downPressed
	sw	zero, rightPressed
	sw	zero, actionPressed
	jr	ra
