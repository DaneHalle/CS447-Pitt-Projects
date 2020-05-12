#Dane Halle (dmh148)

.include "defines.asm"

.text
.globl displayRedraw
.globl displaySetLED
.globl displayGetLED

# int displayWidth()
#   Reports the width of the LED device.
# returns: $v0: The width of the device.
displayWidth:
	li	v0, LED_WIDTH
	jr	ra

# int displayHeight()
#   Reports the height of the LED device.
# returns: $v0: The height of the device.
displayHeight:
	li	v0, LED_HEIGHT
	jr	ra

# void displayRedraw()
#   Tells the LED screen to refresh.
#
# arguments: $a0: when non-zero, clear the screen
# trashes:   $t0-$t1
# returns:   none
displayRedraw:
	li	t0, 0xffff0000
	sw	a0, (t0)
	jr	ra

# void _setLED(int x, int y, int color)
#   sets the LED at (x,y) to color
#   color: 0=off, 1=red, 2=yellow, 3=green
#
# arguments: $a0 is x, $a1 is y, $a2 is color
# returns:   none
#
displaySetLED:
	push	s0
	push	s1
	push	s2
	
	# I am trying not to use t registers to avoid
	#   the common mistakes students make by mistaking them
	#   as saved.
	
	#   :)

	# Byte offset into display = y * 16 bytes + (x / 4)
	sll	s0, a1, 6      # y * 64 bytes
	
	# Take LED size into account
	mul	s0, s0, LED_SIZE
	mul	s1, a0, LED_SIZE
		
	# Add the requested X to the position
	add	s0, s0, s1
	
	li	s1, 0xffff0008 # base address of LED display
	add	s0, s1, s0    # address of byte with the LED
	
	# s0 is the memory address of the first pixel
	# s1 is the memory address of the last pixel in a row
	# s2 is the current Y position	
	
	li	s2, 0	
_displaySetLEDYLoop:
	# Get last address
	add	s1, s0, LED_SIZE
	
_displaySetLEDXLoop:
	# Set the pixel at this position
	sb	a2, (s0)
	
	# Go to next pixel
	add	s0, s0, 1
	
	beq	s0, s1, _displaySetLEDXLoopExit
	j	_displaySetLEDXLoop
	
_displaySetLEDXLoopExit:
	# Reset to the beginning of this block
	sub	s0, s0, LED_SIZE
	
	# Move to next row
	add	s0, s0, 64
	
	add	s2, s2, 1
	beq	s2, LED_SIZE, _displaySetLEDYLoopExit
	
	j _displaySetLEDYLoop
	
_displaySetLEDYLoopExit:
	
	pop	s2
	pop	s1
	pop	s0
	jr	ra
	
# int displayGetLED(int x, int y)
#   returns the color value of the LED at position (x,y)
#
#  arguments: $a0 holds x, $a1 holds y
#  returns:   $v0 holds the color value of the LED (0 through 7)
#
displayGetLED:
	push	s0
	push	s1

	# Byte offset into display = y * 16 bytes + (x / 4)
	sll	s0, a1, 6      # y * 64 bytes
	
	# Take LED size into account
	mul	s0, s0, LED_SIZE
	mul	s1, a0, LED_SIZE
		
	# Add the requested X to the position
	add	s0, s0, s1
	
	li	s1, 0xffff0008 # base address of LED display
	add	s0, s1, s0    # address of byte with the LED
	lbu	v0, (s0)
	
	pop	s1
	pop	s0
	jr	ra
