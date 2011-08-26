!********************************************************************
! Functions: chk_par_do_lastprivate
!********************************************************************

	integer function chk_par_do_lastprivate()
        implicit none
	integer sum, known_sum, i , i0
	include "omp_testsuite.f"
	sum = 0
	i0 = -1
!$omp parallel do reduction(+:sum) schedule(static,7) lastprivate(i0)	
	do i=1, LOOPCOUNT
	  sum = sum + i
	  i0 = i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	  chk_par_do_lastprivate = 1
	else
	  chk_par_do_lastprivate = 0
	end if
	end   

	integer function crschk_par_do_lastprivate()
        implicit none
	integer sum, known_sum, i , i0
	include "omp_testsuite.f"
	sum = 0
	i0 = -1
!$omp parallel do reduction(+:sum) schedule(static,7) private(i0)	
	do i=1, LOOPCOUNT
	  sum = sum + i
	  i0 = i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	  crschk_par_do_lastprivate = 1
	else
	  crschk_par_do_lastprivate = 0
	end if
	end   
