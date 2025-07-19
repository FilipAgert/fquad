program main
    use quad
    integer, parameter :: n = 32
    real(8) ::roots(n), weights(n)
    integer :: k
    call LEGQUAD(roots, weights, n)
    call LAGQUAD(roots, weights, n)
    do k =1,n
        write(*,'(I3, A, E22.14, A, E22.14)') k ,"th root found: ", roots(k), ", weight: ", weights(k)
    end do


end program main