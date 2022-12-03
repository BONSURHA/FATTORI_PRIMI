.data 0x10010000
risultati:


.text
main:           li $s2, -15
redo:           slt $t3, $s2, $0
                bne $t3, $0, negative
                move $s3, $s2
                li $v1, 0
                j load
negative:       abs $s3, $s2
		        li $v1, 1
load:           la $s0, risultati
                move $s1, $s0
                

Loop:           li $s4, 2
                sle $t3, $s3, 1
                bne $t3, $0, end_loop
                move $a0, $s3
                jal div2
                move $s5, $v0
                bne $s5, $0, next
                sw $s4, 0($s1)
                addi $s1, $s1, 4
                srl $s3, $s3, 1
                li $s4, 2
                j Loop

next:           slt $t3, $s4, $s3
                beq $t3, $0, redo
                div $s3, $s4
                mfhi $s7
                bne $s7, $0, next
                move $a0, $s4 
                jal prime
                move $s6, $v0
                beq $s6, $0, next
                sw $s4, 0($s1)
                addi $s1, $s1, 4
                div $s3, $s4
                mflo $s3
                li $s4, 2
                j Loop
end_loop:       j end_loop


div2:           move $t0, $a0
                andi $t1, $t0, 0x1
                li $t2,  1   #var boolean
                bne $t1, $0, exit_div2
                move $t2, $0
exit_div2:      move $v0, $t2
                jr $ra


prime:          move $t0, $a0
                move $a0, $t0
                move $t9, $ra
                addi $sp, $sp, -8
                sw $t0, 0($sp)
                sw $t9, 4($sp)
                jal div2
                lw $t0, 0($sp)
                lw $t9, 4($sp)
                addi $sp, $sp, 8   
                move $t4, $v0
                beq $t4, $0, exit_prime
                move $a0, $t0
                addi $sp, $sp, -8
                sw $t0, 0($sp)
                sw $t9, 4($sp)
                jal sqrt
                lw $t0, 0($sp)
                lw $t9, 4($sp)
                addi $sp, $sp, 8
                move $t1, $v0
                li $t2, 3
                li $t4, 1
prime_loop:     sle $t3, $t2, $t1
                beq $t3, $0, exit_prime
                div $t0, $t2
                mfhi $t5
                beq $t5, $0, false
                addi $t2, $t2, 1
                j prime_loop
false:          move $t4, $0                         
exit_prime:     move $v0, $t4
                jr $t9


sqrt:           move $t0, $a0       # n
                move $t1, $0        # i
                move $t2, $t0       # x
                srl $t3, $t0, 1     # n/2
sqrt_loop:      div $t0, $t2        
                mflo $t4             # n/x
                addu $t2, $t2, $t4
                srl $t2, $t2, 1      # x = (x + n/x)/2
                sltu $t5, $t1, $t3      
                addiu $t1, $t1,1
                bne $t5, $0, sqrt_loop
                addu $v0, $t2, $0
                jr $ra

