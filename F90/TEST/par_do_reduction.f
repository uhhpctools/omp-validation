!********************************************************************
! Functions: chk_par_do_reduction
!********************************************************************

	integer function chk_par_do_reduction()
        implicit none
	integer sum,known_sum,i
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do schedule(dynamic,1) reduction(+:sum)
	do i=1, LOOPCOUNT
	  sum = sum + i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum) then
	  chk_par_do_reduction = 1
	else
	  chk_par_do_reduction = 0
	end if
	end 

	integer function crschk_par_do_reduction()
        implicit none
	integer sum, known_sum, i
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do schedule(dynamic,1)
	do i=1, LOOPCOUNT
	  sum = sum + i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum ) then
	  crschk_par_do_reduction = 1
	else
	  crschk_par_do_reduction = 0
	end if
	end

