.data
    newline: .asciiz "\n"

.text
.globl main
main:
    # --- a = 10 ---
    li   $t0, 10            # $t0 = a

    # --- b = 20 ---
    li   $t1, 20            # $t1 = b

    # --- c = a + b * 2 ---
    sll  $t4, $t1, 1        # $t4 = b * 2  (usando shift como reduccion de fuerza)
    add  $t2, $t0, $t4      # $t2 = a + (b*2)   => c

    # --- si (c > 30) entonces ---
    li   $t5, 30
    ble  $t2, $t5, FIN_SI   # si c <= 30, saltar al final del si

        # escribir(c)
        li   $v0, 1
        move $a0, $t2
        syscall
        li   $v0, 4
        la   $a0, newline
        syscall

        # d = c - 10
        addi $t3, $t2, -10   # $t3 = d

FIN_SI:
    # --- escribir(d) ---
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # --- fin ---
    li   $v0, 10
    syscall