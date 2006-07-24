        integer function chk_do_schedule_guided(logfile)
        implicit none
        integer NUMBER_OF_THREADS
        integer CFSMAX_SIZE
        integer MAX_TIME
        integer SLEEPTIME

        parameter( NUMBER_OF_THREADS = 10)
        parameter(CFSMAX_SIZE = 1000)
        parameter(MAX_TIME = 10)
        parameter(SLEEPTIME = 1)

        integer threads
        integer tids(0:CFSMAX_SIZE)
        integer i,m,tmp
        integer,allocatable:: chunksizes(:)
        integer result/1/
        integer notout/1/
        integer maxiter/0/

        character*20 logfile
        integer omp_get_num_threads
        integer omp_get_thread_num

        integer count
        integer tid

        integer global_chunknr
        integer local_chunknr(0:NUMBER_OF_THREADS-1)
        integer openwork
        integer expected_chunk_size

!$omp parallel
!$omp single
        threads = omp_get_num_threads()
!$omp end single
!$omp end parallel

        if( threads .LT.  2) then
                write (*,*)
     &   "This test only works with at least two threads ."
          chk_do_schedule_guided=0
          return
        endif

c       Now the real parallel work:
c
c       Each thread will start immediately with the first chunk.

!$omp parallel shared(tids)
        count=0
        tid = omp_get_thread_num()

!$omp do schedule(guided,1)
        do i=0, CFSMAX_SIZE -1
        count = 0
!$omp flush(maxiter)
            if (i .GT. maxiter) then
!$omp critical
              maxiter=i
!$omp end critical
             endif

c       if it is not our turn we wait
c       a) until another thread executed an iteration
c          with a higher iteration count
c       b) we are at the end of the loop (first thread
c          finished and set notout=0
c       c) timeout arrived

             do while(notout .ge. 1.and.count .LT. MAX_TIME
     &        .and.  maxiter .EQ. i )
!$omp flush(maxiter,notout)
               call sleep(SLEEPTIME)
               count= count + SLEEPTIME
             end do

             tids(i) = tid
        end do
!$omp end do nowait

        notout = 0
!$omp flush(notout)

!$omp end parallel

c       print *, "end of // region of check guided"

        m=1
        tmp=tids(0)

        global_chunknr=0
        openwork = CFSMAX_SIZE

        do i = 0, NUMBER_OF_THREADS-1
                local_chunknr(i)=0
        enddo

        tids(CFSMAX_SIZE)= -1

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                  m = m+1
                else
                  write (1,*) global_chunknr,tmp,
     &             local_chunknr(tmp),m
                  global_chunknr = global_chunknr + 1
                  local_chunknr(tmp) = local_chunknr(tmp) + 1
                  tmp = tids(i)
                  m = 1
                endif
        enddo

        allocate ( chunksizes(0:global_chunknr-1) )

        global_chunknr = 0

        m = 1
        tmp=tids(0)

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                        m = m+1
                else
                 chunksizes(global_chunknr) = m
                 global_chunknr = global_chunknr + 1
                 local_chunknr(tmp)=local_chunknr(tmp)+1
                 tmp = tids(i)
                 m = 1
                endif
        enddo

        do i = 0, global_chunknr-1
                if( expected_chunk_size .GT. 2) then
                  expected_chunk_size=openwork/threads
                endif
                if (result .ge. 1 .and.
     &    abs(chunksizes(i)-expected_chunk_size) .LT. 2) then
                   result = 1
                else
                   result = 0
                end if
                openwork = openwork - chunksizes(i)
        enddo

c       print *,"check guided=",result
        chk_do_schedule_guided = result

        end


        integer function crschk_do_schedule_guided(logfile)
        integer NUMBER_OF_THREADS
        integer CFSMAX_SIZE
        integer MAX_TIME
        integer SLEEPTIME

        parameter( NUMBER_OF_THREADS = 10)
        parameter(CFSMAX_SIZE = 1000)
        parameter(MAX_TIME = 10)
        parameter(SLEEPTIME = 1)

        integer threads
        integer tids(0:CFSMAX_SIZE)
        integer i,m,tmp
        integer,allocatable:: chunksizes(:)
        integer result/1/
        integer notout/1/
        integer maxiter/0/

        character*20 logfile
        integer omp_get_num_threads
        integer omp_get_thread_num

        integer count
        integer tid

        integer global_chunknr
        integer local_chunknr(0:NUMBER_OF_THREADS-1)
        integer openwork
        integer expected_chunk_size

!$omp parallel
!$omp single
        threads = omp_get_num_threads()
!$omp end single
!$omp end parallel

        if( threads .LT.  2) then
                write (*,*)
     &   "This test only works with at least two threads ."
          chk_do_schedule_guided=0
          return
        endif

c       Now the real parallel work:
c
c       Each thread will start immediately with the first chunk.

!$omp parallel shared(tids)
        count=0
        tid = omp_get_thread_num()

!$omp do
        do i=0, CFSMAX_SIZE -1
        count = 0
!$omp flush(maxiter)
            if (i .GT. maxiter) then
!$omp critical
              maxiter=i
!$omp end critical
             endif

c       if it is not our turn we wait
c       a) until another thread executed an iteration
c          with a higher iteration count
c       b) we are at the end of the loop (first thread
c          finished and set notout=0
c       c) timeout arrived

             do while(notout .ge. 1.and.count .LT. MAX_TIME
     &        .and.  maxiter .EQ. i )
!$omp flush(maxiter,notout)
               call sleep(SLEEPTIME)
               count= count + SLEEPTIME
             end do

             tids(i) = tid
        end do
!$omp end do nowait

        notout = 0
!$omp flush(notout)

!$omp end parallel

c       print *, "end of // region of check guided"

        m=1
        tmp=tids(0)

        global_chunknr=0
        openwork = CFSMAX_SIZE

        do i = 0, NUMBER_OF_THREADS-1
                local_chunknr(i)=0
        enddo

        tids(CFSMAX_SIZE)= -1

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                  m = m+1
                else
                  write (1,*) global_chunknr,tmp,
     &             local_chunknr(tmp),m
                  global_chunknr = global_chunknr + 1
                  local_chunknr(tmp) = local_chunknr(tmp) + 1
                  tmp = tids(i)
                  m = 1
                endif
        enddo

        allocate ( chunksizes(0:global_chunknr-1) )

        global_chunknr = 0

        m = 1
        tmp=tids(0)

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                        m = m+1
                else
                 chunksizes(global_chunknr) = m
                 global_chunknr = global_chunknr + 1
                 local_chunknr(tmp)=local_chunknr(tmp)+1
                 tmp = tids(i)
                 m = 1
                endif
        enddo

        do i = 0, global_chunknr-1
                if( expected_chunk_size .GT. 2) then
                  expected_chunk_size=openwork/threads
                endif
                if (result .ge. 1 .and.
     &    abs(chunksizes(i)-expected_chunk_size) .LT. 2) then
                   result = 1
                else
                   result = 0
                end if
                openwork = openwork - chunksizes(i)
        enddo

c       print *,"crosscheck guided=",result
        crschk_do_schedule_guided = result

        end

