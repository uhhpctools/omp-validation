!********************************************************************
! Functions: chk_omp_master_thread
!********************************************************************

	integer function chk_omp_master_thread()
        implicit none
	integer nthreads, executing_thread
        integer omp_get_thread_num
        nthreads=0
	executing_thread=-1
!$omp parallel
!$omp master
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
	executing_thread=omp_get_thread_num()
!$omp end master
!$omp end parallel
	if ( nthreads .eq. 1 .and. executing_thread .eq. 0) then
 	  chk_omp_master_thread = 1
        else
	  chk_omp_master_thread = 0
	end if
	end

	integer function crschk_omp_master_thread()
        implicit none
	integer nthreads, executing_thread
	integer omp_get_thread_num
        nthreads=0
        executing_thread=-1
!$omp parallel
!$omp critical
	nthreads = nthreads + 1
!$omp end critical
!$omp end parallel     	
	executing_thread=omp_get_thread_num()
	if ( nthreads .eq. 1 .and. executing_thread .eq. 0) then
          crschk_omp_master_thread = 1
        else
          crschk_omp_master_thread = 0
        end if
        end

