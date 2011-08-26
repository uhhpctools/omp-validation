!********************************************************************
! Functions: chk_single
!********************************************************************

	integer function chk_single()
        implicit none
	integer nr_threads_in_single, result, nr_iterations,i
	include "omp_testsuite.f"
	nr_threads_in_single=0
	result=0	
	nr_iterations=0
!$omp parallel
	do i=0, LOOPCOUNT-1
!$omp single
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  nr_iterations = nr_iterations + 1
	  nr_threads_in_single = nr_threads_in_single - 1
	  result = result + nr_threads_in_single
!$omp end single
	end do
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT ) then
	   chk_single = 1
	else
	   chk_single = 0
	end if
	end

	integer function crschk_single()
        implicit none
        integer nr_threads_in_single, result, nr_iterations,i
        include "omp_testsuite.f"
        nr_threads_in_single=0
        result=0
        nr_iterations=0
!$omp parallel
        do i=0, LOOPCOUNT-1
!$omp single
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  nr_iterations = nr_iterations + 1
	  nr_threads_in_single = nr_threads_in_single + 1
	  result = result + nr_threads_in_single
!$omp end single
	end do
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT ) then
	  crschk_single = 1
	else
	  crschk_single = 0
	end if
	end

