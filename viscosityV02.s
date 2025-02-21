.global acumula_pasos
.global suma_vect
.global escala_vect
.global vector_sobre_escalar
.global _start

_start:
    call acumula_pasos  ! Llamar a la función principal
    nop

suma_vect:
    retl
    nop

escala_vect:
    retl
    nop

vector_sobre_escalar:
    retl
    nop

acumula_pasos:
    save %sp, -96, %sp      ! Crear nuevo marco de pila

    sub %g0, %i3, %l3       ! kv negativo -> %l3 = -kv
    mov %i1, %l1            ! Copiar posición inicial en %l1
    mov %i2, %l2            ! Copiar velocidad inicial en %l2
    mov %i4, %l0            ! Inicializar contador de pasos

    mov 1, %g1              ! Constante 1
    mov 2, %g2              ! Constante 2

bucle:
    subcc %l0, %g1, %l0     ! Decrementar pasos
    be fin
    nop

    ! Calcular fuerza F = -kv * V
    mov %l2, %o0
    mov %l3, %o1
    call escala_vect
    nop
    mov %o0, %l4            ! Guardar F en %l4

    ! Actualizar velocidad: V = V + F * dt
    mov %l4, %o0
    mov %i5, %o1
    call escala_vect
    nop
    add %l2, %o0, %l2       ! Nueva velocidad v = v + (F * dt)

    ! Calcular delta_pos = (V * t) + (A * t * t / 2)
    mov %l2, %o0
    mov %i5, %o1
    call escala_vect
    nop
    mov %o0, %l5            ! Guardar V * t en %l5

    mov %l4, %o0
    mov %i5, %o1
    call escala_vect
    nop
    mov %o0, %l6            ! Guardar A * t en %l6

    mov %l6, %o0
    mov %i5, %o1
    call escala_vect
    nop
    mov %o0, %l7            ! Guardar A * t * t en %l7

    mov %l7, %o0
    mov %g2, %o1
    call vector_sobre_escalar
    nop
    mov %o0, %l6            ! Guardar A * t * t / 2 en %l6

    mov %l5, %o0
    mov %l6, %o1
    call suma_vect
    nop
    mov %o0, %l7            ! Guardar delta_pos en %l7

    ! Actualizar posición: Pos = Pos + delta_pos
    mov %l1, %o0
    mov %l7, %o1
    call suma_vect
    nop
    mov %o0, %l1            ! Guardar nueva posición en %l1

    ! Guardar posición en lista
    st %l1, [%o2]
    add %o2, 4, %o2         ! Mover puntero de la lista

    ba bucle
    nop

fin:
    mov %o2, %o1            ! Devolver dirección de lista
    ret
    restore
