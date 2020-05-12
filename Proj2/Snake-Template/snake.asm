#Dane Halle (dmh148)
#Snake Souce Code
#------------------------------------------
#(s3, s4) = (x, y) of snake
#s5=score
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
	

.data
	cycleCount: .word 0
	snake_x: .word 0:30
	snake_y: .word 0:30
	snake_movement: .word 0:30
	appleGood: .word 0:1
	appleBad: .word 0:1

.include "defines.asm"

.text
.globl snakeInitial
.globl snakeDraw
.globl snakeUpdate
.globl spawnApple

#Failed attempt at getting the snake tail part working
##########################################

shiftSnakeStart:
	push ra
	push s0
	push s1
	push s2
	push s6
	move s0, s5
	#subi s0, s0, 1
	la s1, snake_x
	la s2, snake_y
	la s6, snake_movement
	#sw s3, (s1)
	#sw s4, (s2)
	#sw a3, (s6)	
	#addi s1, s1, 4
	#addi s2, s2, 4
	#addi s6, s6, 4
	
shiftSnake:
	ble s0, 0, shiftSnakeEnd
	lw t1, (s1)
	lw t2, (s2)
	lw t3, (s6)
	addi s1, s1, 4
	addi s2, s2, 4
	addi s6, s6, 4
	sw t1, (s1)
	sw t2, (s2)
	sw t3, (s6)
	move a0, t1
	move a1, t2
	subi s0, s0, 1
	li a2, LED_MAGENTA
	jal displaySetLED
	j shiftSnake
	
	
shiftSnakeEnd:
	pop s6
	pop s2
	pop s1
	pop s0
	pop ra
	jr ra

#Failed attempt at getting the snake tail part working
##########################################

addUnitStart:
	push ra
	push s0
	push s1
	push s2
	move s0, s5
	la t7, snake_movement
	
addUnitLoop:
	jal getX
	jal getY
	beq t7, 1, addUnitUp
	beq t7, 2, addUnitDown
	beq t7, 3, addUnitLeft
	beq t7, 4, addUnitRight
	#sw s3, (s1)
	#sw s4, (s2)
	subi s0, s0, 1
	bge s0, 0, addUnitLoop
	j addUnitEnd
	
addUnitUp:
	lw t0, (s1)
	lw t1, (s2)
	mul t2, s0, 1
	add t1, t1, t2
	sw t0, (s1)
	sw t1, (s2)
	
	move a0, t0
	move a1, t1
	li a2, LED_MAGENTA
	jal displaySetLED
	
	addi t7, t7, 4
	
	subi s0, s0, 1
	bge s0, 0, addUnitLoop
	j addUnitEnd

addUnitDown:
	lw t0, (s1)
	lw t1, (s2)
	mul t2, s0, -1
	add t1, t1, t2
	sw t0, (s1)
	sw t1, (s2)
	
	move a0, t0
	move a1, t1
	li a2, LED_MAGENTA
	jal displaySetLED
	
	addi t7, t7, 4
	
	subi s0, s0, 1
	bge s0, 0, addUnitLoop
	j addUnitEnd

addUnitLeft:
	lw t0, (s1)
	lw t1, (s2)
	mul t2, s0, 1
	add t0, t0, t2
	sw t0, (s1)
	sw t1, (s2)
	
	move a0, t0
	move a1, t1
	li a2, LED_MAGENTA
	jal displaySetLED
	
	addi t7, t7, 4
	
	subi s0, s0, 1
	bge s0, 0, addUnitLoop
	j addUnitEnd

addUnitRight:
	lw t0, (s1)
	lw t1, (s2)
	mul t2, s0, -1
	add t0, t0, t2
	sw t0, (s1)
	sw t1, (s2)
	
	move a0, t0
	move a1, t1
	li a2, LED_MAGENTA
	jal displaySetLED
	
	addi t7, t7, 4
	
	subi s0, s0, 1
	bge s0, 0, addUnitLoop
	j addUnitEnd
	
addUnitEnd:
	pop s2
	pop s1
	pop s0
	pop ra
	jr ra
	
getX:
	push ra
	la t0, snake_x
	mul t1, s0, 4
	add s1, t0, t1
	pop ra
	jr ra

getY:
	push ra
	la t0, snake_y
	mul t1, s0, 4
	add s2, t0, t1
	pop ra
	jr ra

#The following code is associated to the spawning and eating of apples
##########################################

spawnApple:
	push ra
	j spawnAppleLoop
	
spawnAppleLoop:
	bge s6, 1, spawnAppleExit
	
	la t0, appleGood
	la t1, appleBad
	
	li a0, 60
	jal getRandomInt
	addi a0, a0, 2
	sw a0, (t0)
	addi t0, t0, 4
	
	li a0, 60
	jal getRandomInt
	addi a0, a0, 2
	sw a0, (t0)
	subi t0, t0, 4
	
	li a0, 60
	jal getRandomInt
	addi a0, a0, 2
	sw a0, (t1)
	addi t1, t1, 4
	
	li a0, 60
	jal getRandomInt
	addi a0, a0, 2
	sw a0, (t1)
	subi t1, t1, 4
	
	lw a0, (t1)
	addi t1, t1, 4
	lw a1, (t1)
	jal displayGetLED
	bne v0, 0, spawnAppleLoop
	
	lw a0, (t0)
	addi t0, t0, 4
	lw a1, (t0)
	jal displayGetLED
	bne v0, 0, spawnAppleLoop
	
	li s6, 1
	j spawnAppleExit
	
spawnAppleExit:
	la t0, appleGood
	la t1, appleBad
	
	lw a0, (t0)
	addi t0, t0, 4
	lw a1, (t0)
	li a2, LED_RED
	jal displaySetLED
	
	lw a0, (t1)
	addi t1, t1, 4
	lw a1, (t1)
	li a2, LED_GREEN
	jal displaySetLED
  	pop ra
  	jr ra
  
goodAppleEaten:
	li s6, 0
	addi s5, s5, 2
	move a0, s1
	move a1, s2
	li a2, LED_DARKGRAY
	jal displaySetLED
	j snakeUpdateExit
	
badAppleEaten:
	li s6, 0
	subi s5, s5, 2
	move a0, s0
	move a1, s7
	li a2, LED_DARKGRAY
	jal displaySetLED
	j snakeUpdateExit

#The following code is associated with updating the snake with inputs
##########################################
  
snakeUpdate:
	push ra
	push s0
	
	#blt s5, 1, snakeUpdateExit
	
	j updateInput
	
snakeUpdateExit:
	
	pop s0
	pop ra
	jr ra
	
updateInput:
	jal handleInput
	lw t0, upPressed
	beq t0, 1, moveUp
	lw t0, downPressed
	beq t0, 1, moveDown
	lw t0, leftPressed
	beq t0, 1, moveLeft
	lw t0, rightPressed
	beq t0, 1, moveRight
	beq a3, 1, moveUp
	beq a3, 2, moveDown
	beq a3, 3, moveLeft
	beq a3, 4, moveRight
	j snakeUpdateExit

#The following is associated with moving the snake up	
##########################################
	
cycleUp:
	lw t0, cycleCount
	addi t0, t0, 1
	sw t0, cycleCount
	j moveUp
			
moveUp:
	beq a3, 2, moveDown
	
	li t1, 1345
	move t0, s5
	li t2, 40
	sub t0, t2, t0
	mul t1, t0, t1
	
	lw t0, cycleCount
	bne t0, t1, cycleUp
	li t0, 0
	sw t0, cycleCount
	
	li a3, 1
	move a0, s3
	move a1, s4
	
	ble a0, 0, hitWall
	ble a1, 0, hitWall
	bge a0, 64, hitWall
	bge a1, 64, hitWall
	
	addi a1, a1, -1
	jal displayGetLED
	beq v0, 1, goodAppleEaten
	beq v0, 4, badAppleEaten
	bne v0, 0, hitWall
	
	
	move a0, s3
	move a1, s4
	
	li a2, LED_DARKGRAY
	jal displaySetLED
	
	li t0, -1
	add s4, s4, t0
	add a1, a1, t0
	
	li a2, LED_MAGENTA
	jal displaySetLED
	
	
	
	j snakeUpdateExit
	

	
#The following is associated with moving the snake down
##########################################
	
cycleDown:
	lw t0, cycleCount
	addi t0, t0, 1
	sw t0, cycleCount
	j moveDown
	
moveDown:
	beq a3, 1, moveUp
	
	li t1, 1345
	move t0, s5
	li t2, 40
	sub t0, t2, t0
	mul t1, t0, t1
	
	lw t0, cycleCount
	bne t0, t1, cycleDown
	li t0, 0
	sw t0, cycleCount
	
	li a3, 2
	move a0, s3
	move a1, s4
	
	ble a0, 1, hitWall
	ble a1, 1, hitWall
	bge a0, 63, hitWall
	bge a1, 63, hitWall
	
	addi a1, a1, 1
	jal displayGetLED
	beq v0, 1, goodAppleEaten
	beq v0, 4, badAppleEaten
	bne v0, 0, hitWall
	
	move a0, s3
	move a1, s4
	
	li a2, LED_DARKGRAY
	jal displaySetLED
	
	li t0, 1
	add s4, s4, t0
	add a1, a1, t0
	
	li a2, LED_MAGENTA
	jal displaySetLED
	
	j snakeUpdateExit
	
#The following is associated with moving the snake left
##########################################
	
cycleLeft:
	lw t0, cycleCount
	addi t0, t0, 1
	sw t0, cycleCount
	j moveLeft

moveLeft:
	beq a3, 4, moveRight 
	
	li t1, 1345
	move t0, s5
	li t2, 40
	sub t0, t2, t0
	mul t1, t0, t1
	
	lw t0, cycleCount
	bne t0, t1, cycleLeft
	li t0, 0
	sw t0, cycleCount
	
	li a3, 3
	move a0, s3
	move a1, s4
	
	ble a0, 1, hitWall
	ble a1, 1, hitWall
	bge a0, 63, hitWall
	bge a1, 63, hitWall
	
	addi a0, a0, -1
	jal displayGetLED
	beq v0, 1, goodAppleEaten
	beq v0, 4, badAppleEaten
	bne v0, 0, hitWall
	
	move a0, s3
	move a1, s4
	
	li a2, LED_DARKGRAY
	jal displaySetLED
	
	li t0, -1
	add s3, s3, t0
	add a0, a0, t0
	
	li a2, LED_MAGENTA
	jal displaySetLED
	
	j snakeUpdateExit

#The following is associated with moving the snake right	
##########################################
	
cycleRight:
	lw t0, cycleCount
	addi t0, t0, 1
	sw t0, cycleCount
	j moveRight
	
moveRight:
	beq a3, 3, moveLeft

	li t1, 1345
	move t0, s5
	li t2, 40
	sub t0, t2, t0
	mul t1, t0, t1

	lw t0, cycleCount
	bne t0, t1, cycleRight
	li t0, 0
	sw t0, cycleCount
	
	li a3, 4
	move a0, s3
	move a1, s4
	
	ble a0, 1, hitWall
	ble a1, 1, hitWall
	bge a0, 63, hitWall
	bge a1, 63, hitWall
	
	addi a0, a0, 1
	jal displayGetLED
	beq v0, 1, goodAppleEaten
	beq v0, 4, badAppleEaten
	bne v0, 0, hitWall
	
	move a0, s3
	move a1, s4
	
	li a2, LED_DARKGRAY
	jal displaySetLED
	
	li t0, 1
	add s3, s3, t0
	add a0, a0, t0
	
	li a2, LED_MAGENTA
	jal displaySetLED
	
	j snakeUpdateExit

#The following code is the hitWall code and snakeDraw and snakeInitial
##########################################

hitWall:
	subi s5, s5, 1
	j snakeUpdateExit
	
snakeDraw:
	push ra
	move a0, s3
	move a1, s4
	li a2, LED_MAGENTA
	jal displaySetLED
	
	li a0, 0
	jal displayRedraw
	
	pop ra
	jr ra

snakeInitial:
	push ra
	
	li a3, 3
	la t0, snake_x
	la t1, snake_y
	sw s3, (t0)
	sw s4, (t1)
	li s5, 0
	
	pop ra
	jr ra
