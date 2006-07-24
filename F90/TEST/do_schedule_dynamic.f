        integer function chk_do_schedule_dynamic(logfile)
        integer tid
        integer MAX_SIZE
        parameter (MAX_SIZE = 1000000)

        integer tids(0:MAX_SIZE-1)
        integer i
        integer,allocatable:: tmp(:)
        integer chunk_size/10/,count/0/,result/1/,tmp_count/0/
        integer omp_get_thread_num

        character*20 logfile

c       open(1,FILE = logfile)

c       print *, "check dynamic"

!$omp parallel private(tid) shared(tids,count)

        tid = omp_get_thread_num()

!$omp do schedule(dynamic,chunk_size)
        do i = 0, MAX_SIZE-1
                tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i = 0,MAX_SIZE-2
                if (tids(i) .NE. tids(i+1)) then
                        count = count + 1
                endif
        end do

        allocate(tmp(0:count))
        tmp(0) = 1

        do i = 0, MAX_SIZE - 2
                if (tmp_count .GT. count) then
                        write (*,*) "--------------------"
                        write (*,*) "Testinternal Error: List too small"
                        write (*,*) "--------------------"
                        exit
                endif
                if (tids(i) .NE. tids(i+1)) then
                        tmp_count = tmp_count + 1
                        tmp(tmp_count) = 1
                else
                        tmp(tmp_count) = tmp(tmp_count) + 1
                endif
        end do
c       is dynamic statement working

        do i = 0, count
          if (tmp(i) .NE. chunk_size) then
                result = result + ((tmp(i)/chunk_size) - 1)
          endif
        end do
        if ((tmp(0) .NE. MAX_SIZE ) .and. (result .GT. 1)) then
                write (1,*) "Seem to work. (Treads got", result,
     &     "times chunks twice by a total of",
     &      MAX_SIZE/chunk_size,"chunks"
                chk_do_schedule_dynamic= 1
c               return
        else
                write (1,*) "Test negative"
                chk_do_schedule_dynamic= 0
c               return
        endif
c       print *, "dynmic=",chk_do_schedule_dynamic

        end

        integer function crschk_do_schedule_dynamic(logfile)
        integer tid
        integer MAX_SIZE
        parameter (MAX_SIZE = 1000000)

        integer tids(0:MAX_SIZE)
        integer i
        integer,allocatable:: tmp(:)
        integer chunk_size/10/,count/0/,result/1/,tmp_count/0/
        integer omp_get_thread_num

        character*20 logfile

c       open(1,FILE = logfile)

!$omp parallel private(tid) shared(tids,count)

        tid = omp_get_thread_num()

!$omp do
        do i = 0, MAX_SIZE-1
                tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i = 0,MAX_SIZE-2
                if (tids(i) .NE. tids(i+1)) then
                        count = count + 1
                endif
        end do

        allocate(tmp(0:count))
        tmp(0) = 1

        do i = 0, MAX_SIZE - 2
                if (tmp_count .GT. count) then
                        write (*,*) "--------------------"
                        write (*,*) "Testinternal Error: List too small"
                        write (*,*) "--------------------"
                        exit
                endif
                if (tids(i) .NE. tids(i+1)) then
                        tmp_count = tmp_count + 1
                        tmp(tmp_count) = 1
                else
                        tmp(tmp_count) = tmp(tmp_count) + 1
                endif
        end do
c       is dynamic statement working

        do i = 0, count
          if (tmp(i) .NE. chunk_size) then
                result = result + ((tmp(i)/chunk_size) - 1)
          endif
        end do

        if ((tmp(0) .NE. MAX_SIZE ) .and. (result .GT. 1)) then
c               write (1,*) "Seem to work. (Treads got", result,
c     &     "times chunks twice by a total of",
c     &      MAX_SIZE/chunk_size,"chunks"
                crschk_do_schedule_dynamic= 1
c               return
        else
c               write (1,*) "Test negative"
                crschk_do_schedule_dynamic= 0
c               return
        endif
c       print *, "dynmic=",crschk_do_schedule_dynamic

        end

