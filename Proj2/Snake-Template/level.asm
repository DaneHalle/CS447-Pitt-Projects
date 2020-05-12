#Dane Halle (dmh148)
#Level Source Code
#------------------------------------------
#s7 is counting register for parsing the levels
#(s3, s4) = (x, y) of snake
#------------------------------------------
#Bugs: 	- When you hit the edge of the LED pannel, you can't get away from it
#	- Game sometimes crashes for seemingly no reason (always in display .asm line 77)
#	- At times, the apples seem to spawn off screen or under level elements (rare occurance) 
#	- No "tail" or size increase 
#------------------------------------------
#Instructions: 	- Assemble and run with Keypad and LEDu Display open and connected to MIPS
#		- Use arrow keys for movement and 'B' for changing the gates (while pressed, gates change)
#		- Red apples = good apples  |  Green apples = bad apples
#		- After collecting 5 good apples, the level will progress but if you lose enough points 
#			to put you into the previous level, you will go back and speed will decrease
#		- When you collect an apple, the snake won't increase in size as I attempted to and failed. 
#		- You win after your score goes over 30 (15 good apples without mistakes)
#		- Since I do not have the size increase, "shrinking" is score deduction
#			0-9 = Level 1  |  10-19 = Level 2  |  20-29 = Level 3

.include "defines.asm"

.globl levelInitialize
.globl levelUpdate
.globl levelDraw

.data

# Actual levels are in levels.asm for convenience
	cycles: .word 0

.text
#Initilization of level file. Calls levelDraw to put values into s registers
levelInitialize:
	push	ra
	#jal levelDraw
	pop	ra
	jr	ra

#Checks when actionPressed is 1 and switches gates if 1 or if 0
levelUpdate:
	push	ra
	push s0
	push s7
	
	li a2, LED_WHITE
	li s7, 0
	
	jal handleInput
	lw t0, actionPressed
	
	beq t0, 1, turnActionLoop
	beq t0, 0, actionLoop
	
#exit of loop
updateExit:
	
	pop s7
	pop s0
	pop	ra
	jr	ra					# return ret;
	
#loop for if actionPressed is 1
actionLoop:
	bge s7, 4096, updateExit
	li t0, 64
	div s7, t0
	mfhi a1
	mflo a0
	b check_action_d
	blt s7, 4096, actionLoop
	
	jr ra
	
incrimentAction:
	lw t0, cycles
	addi t0, t0, 1
	sw t0, cycles
	j check_action_d
	
#checks byte for 'd' when actionPressed is 1
check_action_d:
	#lw t0, cycles
	#bne t0, 10000, incrimentAction
	#li t0, 0
	#sw t0, cycles
	
	la t0, levels
	move t1, s5
	li t2, 10
	div t1, t2
	mflo t1
	mul t1, t1, 4096
	add t0, t0, t1
	mul t1, a1, 63
	add t1, t1, a1
	add t2, t0, t1
	add s0, t2, a0
	
	li t0, 'd'
	lb t1, (s0)
	addi s7, s7, 1
	bne t0, t1, check_action_D
	li a2, LED_DARKGRAY
	jal displaySetLED
	blt s7, 4096, actionLoop
	
	bge s7, 4096, updateExit
	
#checks byte for 'D' when actionPressed is 1
check_action_D:
	li t0, 'D'
	lb t1, (s0)
	bne t0, t1, check_draw_x
	li a2, LED_ORANGE
	jal displaySetLED
	blt s7, 4096, actionLoop
	
	bge s7, 4096, updateExit
	
#checks byte for 'x'
check_draw_x:
	li t0, 'x'
	lb t1, (s0)
	bne t0, t1, actionLoop
	li a2, LED_WHITE
	jal displaySetLED
	blt s7, 4096, actionLoop
	
	bge s7, 4096, updateExit

#loop for if actionPressed is 0
turnActionLoop:
	bge s7, 4096, updateExit
	li t0, 64
	div s7, t0
	mfhi a1
	mflo a0
	b turn_action_d
	blt s7, 4096, turnActionLoop
	
	jr ra
	
incrimentTurn:
	lw t0, cycles
	addi t0, t0, 1
	sw t0, cycles
	j turn_action_d
	
	
#checks byte for 'd' when actionPressed is 0
turn_action_d:
	#lw t0, cycles
	#bne t0, 10000, incrimentTurn
	#li t0, 0
	#sw t0, cycles

	la t0, levels
	move t1, s5
	li t2, 10
	div t1, t2
	mflo t1
	mul t1, t1, 4096
	add t0, t0, t1
	mul t1, a1, 63
	add t1, t1, a1
	add t2, t0, t1
	add s0, t2, a0
	
	li t0, 'd'
	lb t1, (s0)
	addi s7, s7, 1
	bne t0, t1, turn_action_D
	li a2, LED_ORANGE
	jal displaySetLED
	blt s7, 4096, turnActionLoop
	
	bge s7, 4096, updateExit
	
#checks byte for 'd' when actionPressed is 1
turn_action_D:
	li t0, 'D'
	lb t1, (s0)
	bne t0, t1, turn_draw_x
	li a2, LED_DARKGRAY
	jal displaySetLED
	blt s7, 4096, turnActionLoop
	
	bge s7, 4096, updateExit
	
#checks byte for 'x'
turn_draw_x:
	li t0, 'x'
	lb t1, (s0)
	bne t0, t1, turnActionLoop
	li a2, LED_WHITE
	jal displaySetLED
	blt s7, 4096, turnActionLoop
	
	bge s7, 4096, updateExit

#Starts to draw the level	
levelDraw:
	push	ra
	push a0
	push a1
	push a2
	push s0
	push s7
	li a2, LED_WHITE
	li s7, 0
	j loop
	
#end of the loop
loop_end:
	#li a0, 0
	#jal displayRedraw
	pop s7
	pop s0
	pop a2
	pop a1
	pop a0
	pop ra
	jr ra
	
#loops
loop:
	bge s7, 4096, loop_end
	li t0, 64
	div s7, t0
	mfhi a1
	mflo a0
	b check_for_x
	blt s7, 4096, loop
	
	jr ra
	
#checks byte for 'x'
check_for_x:
	la t0, levels
	move t1, s5
	li t2, 10
	div t1, t2
	mflo t1
	mul t1, t1, 4096
	add t0, t0, t1
	mul t1, a1, 63
	add t1, t1, a1
	add t2, t0, t1
	add s0, t2, a0
	
	li t0, 'x'
	lb t1, (s0)
	addi s7, s7, 1
	bne t0, t1, check_for_s
	li a2, LED_WHITE
	jal displaySetLED
	blt s7, 4096, loop
	
	bge s7, 4096, loop_end
	
#checks byte for 's' if and only if s3>0. Puts a0 into s3 and a1 into s4
check_for_s:
	bgt s3, 0, loop
	li t0, 's'
	lb t1, (s0)
	bne t0, t1, loop
	addi s3, a0, 0
	addi s4, a1, 0
	blt s7, 4096, loop
	
	bge s7, 4096, loop_end

