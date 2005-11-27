!********************************************************************
! Functions: chk_omp_num_threads
!********************************************************************

	integer function chk_omp_num_threads()
        implicit none
	integer failed, i, max_threads, threads, nthreads
   	integer omp_get_num_threads
	failed = 0
	max_threads = 0
 
!$omp parallel
!$omp master
	max_threads = omp_get_num_threads()       
!$omp end master
!$omp end parallel
!         print *, "max threads:",max_threads
!Yi Wen added omp_Set_dynamics here to make sure num_threads clause work
        call omp_set_dynamic(.TRUE.)
	do threads = 1, max_threads
	  nthreads = 0
!$omp parallel num_threads(threads) reduction(+:failed)
!          print *, threads, omp_get_num_threads()
	  if ( threads .ne. omp_get_num_threads() ) then
	    failed = failed + 1
 	  end if
!$omp atomic
	  nthreads = nthreads + 1
!$omp end parallel
!          print *, threads, nthreads
	  if ( nthreads .ne. threads ) then
	    failed = failed + 1
	  end if
	end do
!Yi Wen at 05062004 modified here: return value should only be 0 or 1
        if(failed .ne. 0) then
	   chk_omp_num_threads = 0
        else
           chk_omp_num_threads = 1
        endif
	end

	integer function crschk_omp_num_threads()
        implicit none
	integer failed, i, max_threads, threads, nthreads
	integer omp_get_num_threads
	failed = 0
	max_threads = 0
!$omp parallel
!$omp master
	max_threads = omp_get_num_threads()
!$omp end master
!$omp end parallel

        do threads=1, max_threads
	  nthreads = 0
!$omp parallel reduction(+:failed)
	  if (threads .ne. omp_get_num_threads() ) then
 	    failed = failed + 1
	  end if
!$omp atomic
	    nthreads = nthreads + 1
!$omp end parallel
	if ( nthreads .eq. threads ) then
 	  failed = failed + 1
 	end if
  	end do
!Yi Wen at 05062004 modified here: return value should only be 0 or 1
        if(failed .ne. 0) then
	    crschk_omp_num_threads = 0
        else
            crschk_omp_num_threads = 1
        endif
	end	

