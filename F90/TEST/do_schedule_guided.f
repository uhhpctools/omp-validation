!********************************************************************
! Functions: chk_do_schedule_guided
! Translated from C version
! by Zhenying Liu of U. of Houston.
!/*
!* Test for guided scheduling
!* Ensure threads get chunks interleavely first
!* Then judge the chunk sizes are decreasing until to a stable value
!* Modifed by Chunhua Liao
!* For example, 100 iteration on 2 threads, chunksize 7
!* one line for each dispatch, 0/1 means thread id
!*0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0  24
!*1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1              18
!*0 0 0 0 0 0 0 0 0 0 0 0 0 0                      14
!*1 1 1 1 1 1 1 1 1 1                              10
!*0 0 0 0 0 0 0 0                                   8
!*1 1 1 1 1 1 1                                     7
!*0 0 0 0 0 0 0                                     7
!*1 1 1 1 1 1 1                                     7
!*0 0 0 0 0                                         5
!*/
!
! the trick here is to let threads grab chunks interleavely.
! Thread A will not proceed until it knows Thread B grabs a chunk after it.
! How does A knows?  By testing that maxiter is greater than A's
!
! Thread A grabs a chunk(c1) first, but not proceeds until thread B grabs
! another chunk(c2) and sets maxiter, which is greater than any iterations
! from c1.
! Similarly , Thread B working on c2  also stops until c1 is finished and
! Thread A grabs chunk(c3) and set maxiter,which is greater than any iteration
!from c2
!********************************************************************
        integer function chk_do_schedule_guided(logfile)
        implicit none
        integer CFSMAX_SIZE, MAX_TIME
        integer omp_get_thread_num,omp_get_num_threads
        character*20 logfile
        integer chunk_size
        integer threads
        integer tmp_count, count
        integer, allocatable :: tmp(:)
        integer i, ii, flag, notout, maxiter
        integer result
! ... choose small iteration space for small sync. overhead
        parameter (CFSMAX_SIZE = 150)
        parameter (MAX_TIME = 5, chunk_size=7)
        integer tids(0:CFSMAX_SIZE-1), tid
        result = 0
        notout = 1
        flag = 0
        maxiter = 0
        count = 0
        tmp_count = 0
!$omp parallel 
!$omp single
        threads = omp_get_num_threads()
!$omp end single
!$omp end parallel
        if ( threads .lt. 2) then
         print *,"This test only works with at least two threads"
         write(1,*) "This test only works with at least two threads"
         chk_do_schedule_guided = 0
         stop
        end if

! ... Now the real parallel work:
! ... Each thread will start immediately with the first chunk.
    
!$omp parallel private(tid,count) shared(tids,maxiter)
         tid = omp_get_thread_num()
!$omp do schedule(guided,chunk_size)
         do i = 0 , CFSMAX_SIZE-1
           count = 0
!$omp flush(maxiter)
           if ( i .gt. maxiter ) then                 
!$omp critical
             maxiter = i
!$omp end critical
           end if

!..         if it is not our turn we wait
!           a) until another thread executed an iteration
!           with a higher iteration count
!           b) we are at the end of the loop (first thread finished
!             and set notout=0 OR
!           c) timeout arrived 

!$omp flush(maxiter,notout)

           if ( notout .ge. 1 .and. count .lt. MAX_TIME
     &          .and. maxiter .eq. i ) then
               do while ( notout .ge. 1 .and. count .lt. MAX_TIME
     &           .and. maxiter .eq. i )
!          print *, "thread waiting:..",tid, ": iter=",i
!                 call sleep(SLEEPTIME)
                 call sleep(1)
                 count = count + 1
               end do         
           end if
!          print *, "......thread passing..",tid, ": iteration=",i 
           tids(i) = tid
          end do
!$omp end do nowait ! bug 161,Liao

          notout = 0

!$omp flush(notout)
!$omp end parallel 

       count = 0

       do i=0, CFSMAX_SIZE - 2
         if ( tids(i) .ne. tids(i+1) ) then
              count = count + 1
         end if
       end do

       allocate( tmp(0:count)  )
       tmp_count = 0
       tmp(0) = 1
! ... calculate the chunksize for each dispatch

       do i=0, CFSMAX_SIZE - 2
         if ( tids(i) .eq. tids(i+1) ) then
           tmp(tmp_count) = tmp(tmp_count) + 1
         else
           tmp_count = tmp_count + 1
           tmp(tmp_count) = 1
         end if
       end do

! ... Check if chunk sizes are decreased until equals to 
! ... the specified one, ignore the last dispatch 
! ... for possible smaller remainder

       flag = 0
       do i=0, count -2
         if ( i .gt. 0 .and. tmp(i) .eq. tmp(i+1) ) then
           flag = 1
         end if
! ... set flag to indicate the Chunk sizes should 
! ... be the same from now on 

         if ( flag .eq. 0 ) then
             if ( tmp(i) .le. tmp(i+1) ) then
                result = result + 1
                write(1,*) "chunk size from ",i,"to ",i+1,
     &                     "not decreased."
             end if
          else if ( tmp(i) .ne. tmp(i+1) ) then
           result = result + 1
           write(1,*) "chunk size not maintained."
          end if
         end do

         if ( result .eq. 0 )then
           chk_do_schedule_guided = 1 
         else
           chk_do_schedule_guided = 0
         end if
       end

       integer function crschk_do_schedule_guided(logfile)
        implicit none
        character*20 logfile
        crschk_do_schedule_guided = 0
       end  
