.global Acumula_pasos
.global Suma_vect
.global Escala_vect
.global Vector_sobre_escalar
.global _start


_start:
Suma_vect:
    Retl
    Nop

Escala_vect:
    Retl
    Nop

Vector_sobre_escalar:
    Retl
    Nop

Acumula_pasos:
    Save %sp, -96, %sp      ! Crear nuevo marco de pila

    Sub %g0, %i3, %l3       ! kv negativo -> %l3 = -kv
    Mov %i1, %l1            ! Copiar Pos_i en %l1
    Mov %i2, %l2            ! Copiar V_i en %l2
    Mov %i4, %l0            ! Inicializar contador de pasos

    Mov 1, %g1              ! Guardar 1 en %g1
    Mov 2, %g2              ! Guardar 2 en %g2

Ciclo:
    Subcc %l0, %g1, %l0     ! Decrementar pasos
    Be Fin
    Nop

    ! Calcular fuerza F = -kv * V
    Mov %l2, %o0
    Mov %l3, %o1
    Call Escala_vect
    Nop
    Mov %o0, %l4            ! Guardar F en %l4

    ! Calcular delta_pos = (V * t) + (A * t * t / 2)
    Mov %l2, %o0
    Mov %i5, %o1
    Call Escala_vect
    Nop
    Mov %o0, %l5            ! Guardar V * t en %l5

    Mov %l4, %o0
    Mov %i5, %o1
    Call Escala_vect
    Nop
    Mov %o0, %l6            ! Guardar A * t en %l6

    Mov %l6, %o0
    Mov %i5, %o1
    Call Escala_vect
    Nop
    Mov %o0, %l7            ! Guardar A * t * t en %l7

    Mov %l7, %o0
    Mov %g2, %o1
    Call Vector_sobre_escalar
    Nop
    Mov %o0, %l6            ! Guardar A * t * t / 2 en %l6

    Mov %l5, %o0
    Mov %l6, %o1
    Call Suma_vect
    Nop
    Mov %o0, %l7            ! Guardar delta_pos en %l7

    ! Actualizar posición: Pos = Pos + delta_pos
    Mov %l1, %o0
    Mov %l7, %o1
    Call Suma_vect
    Nop
    Mov %o0, %l1            ! Guardar nueva posición en %l1

    ! Guardar posición en lista
    St %l1, [%o2]
    Add %o2, 4, %o2         ! Mover puntero de la lista

    Ba Ciclo
    Nop

Fin:
    Mov %o2, %o1            ! Devolver dirección de lista
    Ret
    Restore
