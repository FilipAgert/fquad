module quad
    implicit none
    private
    
    contains


    pure real(8) elemental function hmn(x,n)
        ! Computes the value of the n-th Hermite polynomial at x
        integer, intent(in) :: n
        real(8), intent(in) :: x
        real(8), parameter :: pi = ACOS(-1.0d0), rootrootpi = sqrt(sqrt(pi))
        real(8), dimension(-1:n) ::h
        integer ::i

        h(-1) = 0.0d0
        h(0) = exp(-x**2 / 2.0d0) / rootrootpi
        if(n>0) then
            do i = 0, n-1
                h(i + 1) = sqrt(2.0d0/(i+1)) * x * h(i) - sqrt(real(i)/(i+1)) * h(i-1)
            end do
        endif
        hmn = h(n)
    end function

    pure real(8) elemental function Lmn(x,n)
        ! Computes the value of the n-th laguerre polynomial at x
        integer, intent(in) :: n
        real(8), intent(in) :: x
        real(8), parameter :: pi = ACOS(-1.0d0), rootrootpi = sqrt(sqrt(pi))
        real(8), dimension(-1:n) ::L
        integer ::i

        L(-1) = 0.0d0
        L(0) = exp(-x/ 2.0d0)
        if(n>0) then
            do i = 0, n-1
                L(i + 1) = (2*i + 1  - x)/(i + 1) *L(i) - real(i,8)/(i+1.0d0) * L(i-1)
            end do
        endif
        Lmn = L(n)
    end function
end module quad