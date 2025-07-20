program main
    use quad
    integer, parameter :: n_default = 64
    real(kind=r_kind),allocatable ::roots(:), weights(:)
    real(kind=r_kind) t0, t1
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
        arg1 = "leg"
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
    else
        write(*,*) "Invalid <type> option. Allowed : leg/lag"
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
        write(*,'(A41,E45.32)') "Analytical solution: I = arctan(5) 2/5 = ", atan(5.0_r_kind)*2.0_r_kind/5
        write(*,'(A41,E45.32)') "Quadrature solution: I = ", sum(weights/(1.0_r_kind+25.0_r_kind*roots**2),1)
    else if(arg1 == "lag") then
        write(*,'(A)') "Integrate f(x) = x^3 / (e^(x)-1) with bounds [0, inf]"
        write(*,'(A41,E45.32)') adjustl("Analytical solution: I = pi^4 / 15 = "), ACOS(-1.0_r_kind)**4 / 15
        write(*,'(A41,E45.32)') adjustl("Quadrature solution: I = "), sum(roots**3/(1-exp(-roots))*weights,1)
    else
    endif

end program main