.data
	playerPoints: .word 0
	
	playerDraw: .asciiz "You drew a: "
	currentPoints: .asciiz "Current Points: "
	draw: .asciiz "Would you like a draw?\n"
	
	response: .asciiz "    "
	newLine: .asciiz "\n"

	youBust: .asciiz "You bust\n"
	
	ten: .asciiz "10\n"
	ace: .asciiz "A\n"
	jack: .asciiz "J\n"
	queen: .asciiz "Q\n"
	king: .asciiz "K\n"
	
	
	dealPoints: .word 0
	
	dealTurn: .asciiz "Dealer's turn\n\n"
	dealDraw: .asciiz "Dealer drew a: "
	youWin: .asciiz "Dealer busts! You win!\n"
	youLose: .asciiz "You lose\n"
	
	
.text
.globl main
main:
	
	b _player_draw

	li v0, 10
	syscall
	
_player_draw:
	la a0, playerDraw
	li v0, 4
	syscall
	
	li v0, 42
	li a0, 0
	li a1, 12
	syscall  
	
	beq a0, 0, _player_draw
	beq a0, 1, _player_print_ace
	beq a0, 10, _player_print_ten
	beq a0, 11, _player_print_jack
	beq a0, 12, _player_print_queen
	beq a0, 13, _player_print_king
	
	lw t1, playerPoints
	add t0, a0, t1
	sw t0, playerPoints
	
	li v0, 1
	syscall
	
	la a0, newLine
	li v0, 4
	syscall
	
	b _player_print_points
	
_player_print_points:
	la a0, currentPoints
	li v0, 4
	syscall
	
	lw a0, playerPoints
	li v0, 1
	syscall
	
	la a0, newLine
	li v0, 4
	syscall
	
	b _player_check_lose
	
	
_player_print_ten:
	la a0, ten
	li v0, 4
	syscall
	
	b _player_print_points
	
_player_print_ace:
	lw t1, playerPoints
	addi t0, t1, 1
	sw t0, playerPoints

	la a0, ace
	li v0, 4
	syscall
	
	b _player_print_points
	
_player_print_jack:
	la a0, jack
	li v0, 4
	syscall
	
	b _player_print_points
	
_player_print_queen:
	la a0, queen
	li v0, 4
	syscall
	
	b _player_print_points

_player_print_king:
	la a0, king
	li v0, 4
	syscall
	
	b _player_print_points
	
_player_check_lose:
	lw t0, playerPoints
	ble t0, 9, _player_continue 
	
	la a0, newLine
	li v0, 4
	syscall
	
	la a0, youBust
	syscall
	
	li v0, 10
	syscall
	
_player_continue:
	la a0, draw
	li v0, 4
	syscall
	
	li v0, 8
	la a0, response
	li a1, 2
	syscall
	
	li t0, 'n'
	lb t1, (a0)
	
	la a0, newLine
	li v0, 4
	syscall
	syscall
	
	beq t0, t1, _dealer
	
	b _player_draw
	
	

	
###################################	
_dealer:
	la a0, newLine
	li v0, 4
	syscall

	la a0, dealTurn
	syscall
	
	b _dealer_draw
	
	li v0, 10
	syscall
	
_dealer_draw:
	la a0, dealDraw
	li v0, 4
	syscall
	
	li v0, 42
	li a0, 0
	li a1, 12
	syscall  
	
	beq a0, 0, _dealer_draw
	beq a0, 1, _dealer_print_ace
	beq a0, 10, _dealer_print_ten
	beq a0, 11, _dealer_print_jack
	beq a0, 12, _dealer_print_queen
	beq a0, 13, _dealer_print_king
	
	lw t1, dealPoints
	add t0, a0, t1
	sw t0, dealPoints
	
	li v0, 1
	syscall
	
	la a0, newLine
	li v0, 4
	syscall
	
	b _dealer_print_points

_dealer_print_points:
	la a0, currentPoints
	li v0, 4
	syscall
	
	lw a0, dealPoints
	li v0, 1
	syscall
	
	la a0, newLine
	li v0, 4
	syscall
	
	b _dealer_check_lose
	
	
_dealer_print_ten:
	la a0, ten
	li v0, 4
	syscall
	
	b _dealer_print_points
	
_dealer_print_ace:
	lw t1, dealPoints
	addi t0, t1, 1
	sw t0, dealPoints

	la a0, ace
	li v0, 4
	syscall
	
	b _dealer_print_points
	
_dealer_print_jack:
	la a0, jack
	li v0, 4
	syscall
	
	b _dealer_print_points
	
_dealer_print_queen:
	la a0, queen
	li v0, 4
	syscall
	
	b _dealer_print_points

_dealer_print_king:
	la a0, king
	li v0, 4
	syscall
	
	b _dealer_print_points	

_dealer_check_lose:
	lw t0, dealPoints
	ble t0, 9, _dealer_continue 
	
	la a0, newLine
	li v0, 4
	syscall
	
	la a0, youWin
	syscall
	
	li v0, 10
	syscall
	
_dealer_win:
	la a0, youLose
	li v0, 4
	syscall
	
	li v0, 10
	syscall

_dealer_continue:
	la a0, newLine
	li v0, 4
	syscall
	
	lw t0, playerPoints
	lw t1, dealPoints
	bgt t1, t0, _dealer_win
	
	b _dealer_draw

	li v0, 10
	syscall
