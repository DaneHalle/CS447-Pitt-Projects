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