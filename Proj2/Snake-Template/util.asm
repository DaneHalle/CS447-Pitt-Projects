#Dane Halle (dmh148)

.globl getSystemTime
.globl getRandomInt

.data

.include "defines.asm"

.text

# int getSystemTime()
#   Returns the number of milliseconds since system booted.
getSystemTime:
	# Now, get the current time
	li	v0, SYS_SYSTEM_TIME
	syscall						# a0 = syscall(GET_SYSTEM_TIME);
	
	move	v0, a0
	
	jr	ra					# return v0;
	
# int getRandomInt(a0: maximum number)
#   Returns a random integer between 0 and the maximum given in a0.
getRandomInt:
	move	a1, a0
	li	v0, SYS_RANDOM_INT_RANGE
	li	a0, 0
	syscall
	
	move	v0, a0
	
	jr	ra
