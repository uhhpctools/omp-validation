!********************************************************************
! Functions: chk_do_schedule_static
!********************************************************************

        integer function chk_do_schedule_static(logfile)
        implicit none
        integer CFSMAX_SIZE
        integer omp_get_thread_num,omp_get_num_threads
        character*20 logfile
        integer chunk_size
        integer threads
        integer count
        integer i, ii
        integer result
        parameter (CFSMAX_SIZE = 1000)
        integer tids(0:CFSMAX_SIZE-1), tid
        chunk_size = 7
        result = 0
        ii = 0
!$omp parallel 
!$omp single
        threads = omp_get_num_threads()
!$omp end single
!$omp end parallel
        if ( threads .lt. 2) then
         print *,"This test only works with at least two threads"
         write(1,*) "This test only works with at least two threads"
         chk_do_schedule_static = 0
         stop
        else
         write(1,*) "Using an internal count of ",CFSMAX_SIZE
         write(1,*) "Using a specified chunksize of ",chunk_size
    
!$omp parallel private(tid) shared(tids)
         tid = omp_get_thread_num()
!$omp do schedule(static,chunk_size)
         do i = 0 , CFSMAX_SIZE-1
                tids(i) = tid
         end do
!$omp end do
!$omp end parallel

         do i = 0, CFSMAX_SIZE-1
!... round-robin for static chunk
           ii = mod( i/chunk_size,threads)
           if (tids(i) .NE. ii ) then
             result = result + 1
             write(1,*)"Iteration ",i,"should be assigned to ",
     &          ii,"instead of ",tids(i)
           end if
         end do
        if ( result .eq. 0 )then
          chk_do_schedule_static = 1
        else
          chk_do_schedule_static = 0
        end if
       end if
       end

       integer function crschk_do_schedule_static(logfile)
        implicit none
        integer CFSMAX_SIZE
        integer omp_get_thread_num,omp_get_num_threads
        character*20 logfile
        integer chunk_size
        integer threads
        integer count
        integer i, ii
        integer result
        parameter (CFSMAX_SIZE = 1000)
        integer tids(0:CFSMAX_SIZE-1), tid
        chunk_size = 7
        result = 0
        ii = 0
!$omp parallel 
!$omp single
        threads = omp_get_num_threads()
!$omp end single
!$omp end parallel
        if ( threads .lt. 2) then
         print *,"This test only works with at least two threads"
         write(1,*) "This test only works with at least two threads"
         crschk_do_schedule_static = 0
         stop
        else
         write(1,*) "Using an internal count of ",CFSMAX_SIZE
         write(1,*) "Using a specified chunksize of ",chunk_size
    
!$omp parallel private(tid) shared(tids)
         tid = omp_get_thread_num()
!$omp do 
         do i = 0 , CFSMAX_SIZE-1
                tids(i) = tid
         end do
!$omp end do
!$omp end parallel

         do i = 0, CFSMAX_SIZE-1
!... round-robin for static chunk
           ii = mod( i/chunk_size,threads)
           if (tids(i) .NE. ii ) then
             result = result + 1
!             write(1,*)"Iteration ",i,"should be assigned to ",
!     &          ii,"instead of ",tids(i)
           end if
         end do
        if ( result .eq. 0 )then
          crschk_do_schedule_static = 1
        else
          crschk_do_schedule_static = 0
        end if
       end if
       end  
