program main
    use quad
    integer, parameter :: n_default = 128
    real(kind=kind),allocatable ::roots(:), weights(:)
    real(kind=kind) t0, t1
    integer :: k, nquad
    character(len=50) :: file
    character(len=50) :: arg1, arg2
    integer :: nargs
    nargs = command_argument_count()
    if(nargs == 2) then
        call get_command_argument(1,arg1)
        call get_command_argument(2,arg2)
        read(arg2, *) nquad !!read number of points
    else
        arg1 = "her"
        nquad = n_default
    endif

    if(nquad > 1750) then
        WRITE(*,*) "ERROR: Code cannot handle this large number of quadrature points: nmax=",1750
        STOP
    endif
    allocate(weights(nquad),roots(nquad))

    arg1 = trim(arg1)

    call cpu_time(t0)
    if(arg1 == "leg") then
        call LEGQUAD(roots, weights)
    else if(arg1 == "lag") then
        call LAGQUAD(roots, weights)
    else if(arg1 == "her") then
        call HERQUAD(roots, weights)
    else
        write(*,*) "Invalid <type> option. Allowed : leg/lag/her"
        stop
    endif

    call cpu_time(t1)


    !call HERQUAD(roots, weights, n)
    write(file, '(A3,A,I0,A)') arg1,'quad_',nquad,'.dat'
    write(*,*) file
    open(unit = 3, file=trim(file))

    do k =1,nquad
        write(3,'(E32.20E4, 2x, E32.20E4)')roots(k), weights(k)
    end do
    close(3)
    write(*,'(A,F10.3,A)')"Quadrature evaluated, time taken: ", t1-t0, " s"
    write(*,*)
    write(*,*) "Example usage:"
    if(arg1 == "leg") then
        write(*,'(A)') "Integrate f(x) = 1/(1+25x^2) with bounds [-1, 1]"
        write(*,'(A25,E45.32)') "Analytical solution: I = ", atan(5.0_kind)*2.0_kind/5
        write(*,'(A25,E45.32)') "Quadrature solution: I = ", sum(weights/(1.0_kind+25.0_kind*roots**2),1)
    else if(arg1 == "lag") then
        write(*,'(A)') "Integrate f(x) = x^3 / (e^(x)-1) with bounds [0, inf]"
        write(*,'(A25,E45.32)') adjustl("Analytical solution: I = "), ACOS(-1.0_kind)**4 / 15
        write(*,'(A25,E45.32)') adjustl("Quadrature solution: I = "), sum(roots**3/(1-exp(-roots))*weights,1)
    else if(arg1 == "her") then
        write(*,'(A)') "Integrate f(x) = x^4 * (e^(-x^2) with bounds [-inf, inf]"
        write(*,'(A25,E45.32)') adjustl("Analytical solution: I = "), 3_kind*sqrt(ACOS(-1.0_kind))/4.0_kind
        write(*,'(A25,E45.32)') adjustl("Quadrature solution: I = "), sum(roots**4*weights,1)

    endif

end program main