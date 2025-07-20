program main
    use quad
    integer, parameter :: n = 64
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
        nquad = n
    endif
    allocate(weights(nquad),roots(nquad))

    arg1 = trim(arg1)

    call cpu_time(t0)
    if(arg1 == "leg") then
        call LEGQUAD(roots, weights, nquad)
    else if(arg1 == "lag") then
        call LAGQUAD(roots, weights, nquad)
    else if(arg1 == "her") then
        CALL HERQUAD(roots, weights, nquad)
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

end program main