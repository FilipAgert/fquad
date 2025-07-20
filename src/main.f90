program main
    use quad
    integer, parameter :: n = 64
    real(kind=r_kind) ::roots(n), weights(n), t0, t1
    integer :: k
    character(len=50) :: file
    call cpu_time(t0)
    call LEGQUAD(roots, weights, n)
    call cpu_time(t1)
    !call LAGQUAD(roots, weights, n)
    !call HERQUAD(roots, weights, n)
    write(file, '(A,I0,A)') 'quad_',n,'.dat'
    open(unit = 3, file=file)

    do k =1,n
        write(3,'(E32.20, 2x, E32.20)')roots(k), weights(k)
    end do
    write(*,'(A,F10.3,A)')"Quadrature evaluated, time taken: ", t1-t0, " s"

end program main