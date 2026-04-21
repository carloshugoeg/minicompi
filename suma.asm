.data
    newline: .asciiz "\n"

.text
.globl main
main:
    # --- a = 10 ---
    li   $t0, 10

    # --- b = 20 ---
    li   $t1, 20

    # --- c = suma(a, b) ---
    move $a0, $t0           # primer argumento  (x = a)
    move $a1, $t1           # segundo argumento (y = b)
    jal  suma               # salto con enlace; $ra = dir. retorno
    move $t2, $v0           # c = valor retornado en $v0

    # --- escribir(c) ---
    li   $v0, 1
    move $a0, $t2
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # --- fin ---
    li   $v0, 10
    syscall

# -------------------------------------------------
# funcion suma(x, y): retornar x + y
#   convenciones:
#     $a0 = x, $a1 = y
#     $v0 = valor de retorno
#     $ra = direccion de retorno (guardada por jal)
# -------------------------------------------------
suma:
    add  $v0, $a0, $a1      # v0 = x + y
    jr   $ra                # retorno al llamador