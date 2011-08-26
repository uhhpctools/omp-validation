!********************************************************************
! Functions: chk_par_do_firstprivate
!********************************************************************

	integer function chk_par_do_firstprivate()
        implicit none
	integer sum,known_sum, i2, i
	include "omp_testsuite.f"
	sum =0
	i2 = 3
!$omp parallel do firstprivate(i2) reduction(+:sum)
	do i=1, LOOPCOUNT
	  sum = sum + ( i+ i2)
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2+3*LOOPCOUNT
	if ( known_sum .eq. sum ) then
	  chk_par_do_firstprivate = 1
	else
	  chk_par_do_firstprivate = 0
	end if
	end

	integer function crschk_par_do_firstprivate()
        implicit none
	integer sum, known_sum, i2,i
	include "omp_testsuite.f"
	sum = 0
	i2 = 3
!$omp parallel do private(i2) reduction(+: sum)
	do i=1, LOOPCOUNT	
	  sum = sum + (i+ i2)
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2+3*999
	if ( known_sum .eq. sum ) then
	  crschk_par_do_firstprivate = 1
	else
	  crschk_par_do_firstprivate = 0
	end if
	end 

