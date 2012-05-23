c  **********************************************************************
c  *                                                                    *
c  *                         Function dround                            *
c  *                                                                    *
c  **********************************************************************
c  Double Precision Version 1.0
c  Written by Gordon A. Fenton, Princeton, Nov. 1989
c
c  PURPOSE  returns a real number rounded up or down in the specified digit
c
c  Arguments are as follows;
c
c    x  the supplied real value to be rounded.
c
c    l  an integer specifying the direction rounding is to take place,
c       =  1 implies rounding up (in absolute value) is to take place,
c       =  0 implies rounding to the closest value,
c       = -1 implies rounding down (in absolute value) is to take place.
c
c    k  an integer specifying which digit to round. For example k = 1, l = 1
c       specifies that the first whole digit is to be rounded up, so that
c       1.43 is converted to 2.00, k = 3 implies that the third digit is
c       to be rounded so that 1468 becomes 1500, etc. A negative value of
c       k denotes the decimal digits, so that k = -2 results in 3.141528
c       being rounded to 3.14 if l = 0 or l = -1 and 3.15 if l = 1.
c       A value for k of zero returns the number unchanged.
c
c-----------------------------------------------------------------------------
      real*8 function dround( x, l, k )
      implicit real*8 (a-h,o-z)
      dimension tol(3)
      data zero/0.d0/, tol/0.d0,0.5d0,1.d0/
      data ten/10.d0/

      if( k .eq. 0 ) then
         dround = zero
         return
      elseif( k .lt. 0 ) then
         rmag = ten**k
      else
         rmag = ten**(k-1)
      endif

      irnd   = idint(x/rmag + dsign(tol(l+2),x))
      dround = rmag*dble(irnd)

      return
      end
