        subroutine do_some_work2()
        implicit none
        real i
        double precision sum
        intrinsic sqrt
        include "omp_testsuite.f"
        sum = 0.0
        do i=0, LOOPCOUNT,1.0
           sum = sum + sqrt(i)
!          sum = sum + exp(i)
!          sum = sum + sin(i)
        end do
        end

!********************************************************************
! Functions: chk_par_do_private
!********************************************************************

	integer function chk_par_do_private()
        implicit none
	integer sum,known_sum, i, i2, i3
        include "omp_testsuite.f"
	sum = 0
!$omp parallel do reduction(+:sum) private(i2) schedule(static,1)
	do i=1, LOOPCOUNT
	  i2 = i
!$omp flush
	  call do_some_work2()
!$omp flush
	  sum = sum + i2
	end do
!$omp end parallel do
 	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum ) then
	  chk_par_do_private = 1
	else
	  chk_par_do_private = 0
	end if
	end

	integer function crschk_par_do_private()
        implicit none
	integer sum, known_sum, i, i2, i3
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do reduction(+:sum) schedule(static,1)
	do i=1,LOOPCOUNT
	  i2 = i	
!$omp flush
	  call do_some_work2()	
!$omp flush
	  sum = sum + i2
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum) then
	  crschk_par_do_private = 1
	else
	  crschk_par_do_private = 0
	end if
	end
