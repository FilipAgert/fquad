module quad
    implicit none
    private
    public :: legquad
    type, abstract :: func
        contains
        procedure(eval_interface), deferred :: eval
    end type func

    abstract interface
        pure function eval_interface(self, x) result(y)
            import :: func
            class(func), intent(in) :: self
            real(8), intent(in) :: x
            real(8) :: y
        end function eval_interface
    end interface

    type , extends(func) :: legendre
        integer :: n
        contains
        procedure ::eval => legendre_eval
    end type

    contains

    pure function legendre_eval(self, x) result(y)
        class(legendre), intent(in) :: self
        real(8), intent(in) :: x
        real(8) :: y
        integer :: i

        y = Pn(x,self%n)
    end function legendre_eval

    !! > Subroutine for computing legendre quadrature weights and absiccas 
    !! > 
    !! > The integral
    !! > lb: -1
    !! > ub: 1
    !! > integrand: f(x) dx
    !! > is calculated as:
    !! > integral = sum_i=1,n   leg_w(i) * f(leg_x(i))
    !! > 
    !! > n weights can integrate a polynomial of order 2n + 1 exactly.
    !! > If a 2n+1 polynomial can approximate f(x) well, legendre quadrature of order n is a good choice of quadrature points
    !! > 
    !! > Author: Filip Agert (2025)
    subroutine LEGQUAD(leg_x,leg_w,n)
        integer, intent(in) :: n !! Number of integration points
        real(8), dimension(n), intent(out) :: leg_x !!integration absiccas
        real(8), dimension(n), intent(out) :: leg_w!!integration weights
        real(8) :: guess, x
        type(legendre) ::leg
        integer :: ub, k, lb
        leg = legendre(n=n)
        leg_x =0
        if(mod(n,2) ==0) then
            ub = n/2
            lb = n/2 +1
        else
            ub = (n-1)/2
            lb = ub+2
        endif
        do k =1,ub
            guess =leg_root_approx(n,k-1) !Approximate root
            leg_x(ub-k+1) = find_root(leg, -guess) !Refine root computation
        end do
        
        do k = 1, ub
            leg_x(n-k + 1) = -leg_x(k) !!use mirror symmetry in the roots

        end do


        do k = 1, n !!Calculates weights
            x = leg_x(k)
            leg_w(k) = 2.0d0/((1.0d0-leg_x(k)**2)* Pnd(leg_x(k),n)**2)
        end do
    end subroutine

    real(8) function find_root(f, x0) result(x)
        class(func), intent(in) :: f !!function to evaluate
        real(8), intent(in) :: x0 !!starting guess for root
        real(8) :: fx, dfx, xprev

        integer :: ii
        integer, parameter :: max_iter = 30
        real(8), parameter :: dx =1e-9_8, tol = 1e-14_8
        x = x0
        do ii = 1, max_iter
            
            fx = f%eval(x)
            dfx = (f%eval(x + dx) -fx)/dx

            xprev = x
            x = x - fx / dfx
            if(abs(x-xprev) < tol) exit
        end do

        if (ii == max_iter) then
            write(*,*) "Error: Max iterations reached in finding root. Stopping"
            STOP
        endif

    end function




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

    pure real(8) elemental function Pn(x,n)
        ! Computes the value of the n-th legendre polynomial at x
        integer, intent(in) :: n
        real(8), intent(in) :: x
        real(8), dimension(0:n) ::P
        integer ::i

        P(0) = 1.0d0

        if(n>0) then
            P(1) = x
            do i = 1, n-1
                P(i + 1) = ((2*i + 1)*x * P(i) - i * P(i-1))/(i+1)
            end do
        endif
        Pn = P(n)
    end function

    pure real(8) elemental function Pnd(x,n)
        ! Computes the value of derivative of the n-th legendre polynomial at x
        integer, intent(in) :: n
        real(8), intent(in) :: x

        Pnd = (n)*(x*Pn(x,n)-Pn(x,n-1)) / (x**2 - 1.0d0)
    end function

    pure real(8) elemental function leg_root_approx(n, k)
        ! Approximate the k-th root of the n-th Legendre polynomial via an asymptotic formula with error on order (1/n^5)
        integer, intent(in) :: n, k
        real(8), parameter :: pi = ACOS(-1.0d0)
        real(8) :: theta
        integer :: intpart

        intpart = n/2 - k
        theta = pi * (intpart * 4.0d0 - 1.0d0 ) / (4*n+2)

        leg_root_approx = cos(theta) * (1 - (n-1.0d0) / (8*n**3) - (39.0d0 - 28.0d0/sin(theta)**2)/(384.0d0*n**4))
    end function
end module quad