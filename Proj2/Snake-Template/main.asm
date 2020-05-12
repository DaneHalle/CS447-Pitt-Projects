#Dane Halle (dmh148)
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

# Project 2 - Snake
# ------------------------------------------------------------
# Assemble with "Settings | Assemble all files in directory"
#
# by: wilkie

# System Calls
.include "defines.asm"

.data

# The last polled time
lastTime:		.word	0
gameOver: .asciiz "Game over! You "
win: .asciiz "win!\n"
lose: .asciiz "lose!\n"

.text
.globl main
main:	
	# Initialize the game state
	jal	initialize				# initialize()
	
	# Run our game!
	jal	gameLoop				# gameLoop()
	
	# The game is over.
	# Finish by reporting the score, etc...
	jal	gameExit				# gameExit()

	# Exit
	li	v0, 10
	syscall						# syscall(EXIT)

# void initialize()
#   Initializes the game state.
initialize:
	push	ra
	
	# Clear the screen
	li	a0, 1
	jal	displayRedraw				# displayRedraw(1);	
	# Clear the screen
	li	a0, 1
	jal	displayRedraw				# displayRedraw(1);
	
	# Set our 'last time' to the system time
	jal	getSystemTime				# lastTime = getSystemTime();
	sw	v0, lastTime
	
	jal	levelInitialize				# levelInitialize();
	
	jal levelDraw
	jal snakeInitial
	
	pop	ra
	jr	ra
				
# void gameLoop()
#   Infinite loop for the game logic
gameLoop:
	push	ra

gameLoopStart:						# loop {	
	move	a0, s0
	jal	handleInput				# 	v0 = handleInput();
	
	# Exit the game if the handleInput
	# function tells us to (it won't by default)
	beq	v0, 1, gameLoopExit			# 	if (v0 == 1) { break; }
	
	jal	getSystemTime				#
	move	t0, v0					# 	t0 = getElapsedTime();
	
	lw	t1, lastTime				# 	if (t0 - lastTime < FRAME_TIME) {
	sub	t1, t0, t1				# 		continue;
	blt	t1, FRAME_TIME, gameLoopStart		# 	}
	
	sw	t0, lastTime				# 	lastTime = t0;
	
	# Update our game state
	jal	update					# 	v0 = update();
	
	# Exit the game when any of the components
	# tell us to
	blt s5, 0, gameLoopExit
	bge s5, 30, gameLoopExit
	beq	v0, 1, gameLoopExit			# 	if (v0 == 1) { break; }
	
	# Redraw
	jal	draw					#	draw();
	li	a0, 1
	jal	displayRedraw				# 	displayRedraw(1);
	
	jal	clearInput				#	clearInput()
	
	j	gameLoopStart				# }

gameLoopExit:
	pop	ra
	jr	ra					# return;
	
# void gameExit()
#   The finalize of our game.
gameExit:
	push	ra
	
	# Print out a nice game over string
	la a0, gameOver
	li v0, SYS_PRINT_STRING
	syscall
	blt s5, 0, youLose
	bge s5, 30, youWin
	
	
	#la	a0, strGameOver
	#li	v0, SYS_PRINT_STRING
	#syscall						# syscall(PRINT_STRING, strGameOver);
	
	li	a0, '\n'
	li	v0, SYS_PRINT_CHARACTER
	syscall						# syscall(PRINT_CHARACTER, '\n');
	
	li	a0, '\n'
	li	v0, SYS_PRINT_CHARACTER
	syscall						# syscall(PRINT_CHARACTER, '\n');
	
	pop	ra
	jr	ra
	
youWin:
	push ra
	la a0, win
	li v0, SYS_PRINT_STRING
	syscall
	pop ra
	jr ra
	
youLose:
	push ra
	la a0, lose
	li v0, SYS_PRINT_STRING
	syscall
	pop ra
	jr ra

# bool update()
#   Updates the game for this frame.
# returns: v0: 1 when the game should end.
update:
	push	ra
	push	s0
	
	# Do not quit the game by default
	li	s0, 0					# v0 = 0;
	
	# Ok. Do our game things
	jal	levelUpdate				# v0 = levelUpdate()
	add	s0, s0, v0
	and	s0, s0, 0x1				# s1 = (s1 + v0) & 0x1
	
	jal spawnApple
	jal snakeUpdate
	
	#jal	anotherGameThingUpdate			# v0 = anotherGameThingUpdate()
	#add	s1, s1, v0
	#and	s1, s1, 0x1				# s1 = (s1 + v0) & 0x1
	
	move	v0, s0
	
	pop	s0
	pop	ra
	jr	ra					# return v0;

# void draw()
#   Draws a frame.
draw:
	push	ra
		
	# Ok. Do our game things
	jal	levelDraw				# levelDraw();
	jal snakeDraw
	# Add components here
	#jal	anotherGameThingDraw			# anotherGameThingDraw();
	
	pop	ra
	jr	ra					# return v0;
