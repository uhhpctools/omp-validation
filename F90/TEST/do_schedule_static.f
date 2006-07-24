        integer function chk_do_schedule_static(logfile)
        integer MAX_SIZE
        parameter (MAX_SIZE = 1000000)

        integer chunk_size/10/
        integer tid
        integer tids(0:MAX_SIZE-1)
        integer count/0/
        integer tmp_count/0/
        integer i


        integer,allocatable:: tmp(:)
        integer result/0/

        integer omp_get_thread_num

        character*20 logfile

c       open (1, FILE = logfile)

!$omp parallel private(tid) shared(tids, count)

        tid = omp_get_thread_num()
!$omp do schedule(static,chunk_size)
        do i = 0 , MAX_SIZE-1
                tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i = 0, MAX_SIZE-2
                if (tids(i) .NE. tids(i+1) ) then
                        count = count + 1
                endif
        end do

        allocate(tmp(0:count))
        tmp(0) = 1

        do i = 0, MAX_SIZE-2
                if (tmp_count .GT. count) then
                        write (*,*) "---------------------"
                        write (*,*) "testinternal Error: List too small"
                        write (*,*) "-----------------------------"
                        write (1,*) "-----------------------------"
                        write (1,*) "testinternal Error: List too small"
                        write (1,*) "-----------------------------"
                        exit
                endif

                if (tids(i) .NE. tids(i+1) ) then
                        tmp_count = tmp_count + 1
                        tmp(tmp_count) = 1
                else
                        tmp(tmp_count) = tmp(tmp_count) + 1
                endif
        end do

        do i = 0, count -1
                if ( tmp(i) .NE. chunk_size) then
                        result = result + 1
                endif
        end do


        if (result .EQ. 0) then
                chk_do_schedule_static =  1
        else
                write (1,*) "Error: Thread got",result,
     &              " times consecutive chunk"
                chk_do_schedule_static =0
        endif

        end


        integer function crschk_do_schedule_static(logfile)
        integer MAX_SIZE
        parameter (MAX_SIZE = 1000000)

        integer chunk_size/10/
        integer tid
        integer tids(0:MAX_SIZE-1)
        integer count/0/
        integer tmp_count/0/
        integer i

        integer,allocatable:: tmp(:)
        integer result/0/

        integer omp_get_thread_num


        character*20 logfile

c       open (1, FILE = logfile)

!$omp parallel private(tid) shared(tids, count)

        tid = omp_get_thread_num()
!$omp do
        do i = 0 , MAX_SIZE-1
                tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i = 0, MAX_SIZE-2
                if (tids(i) .NE. tids(i+1) ) then
                        count = count + 1
                endif
        end do

        allocate(tmp(0:count))
        tmp(0) = 1

        do i = 0, MAX_SIZE-2
                if (tmp_count .GT. count) then
                        write (*,*) "---------------------"
                        write (*,*) "testinternal Error: List too small"
                        write (*,*) "-----------------------------"
                        write (1,*) "-----------------------------"
                        write (1,*) "testinternal Error: List too small"
                        write (1,*) "-----------------------------"
                        exit
                endif

                if (tids(i) .NE. tids(i+1) ) then
                        tmp_count = tmp_count + 1
                        tmp(tmp_count) = 1
                else
                        tmp(tmp_count) = tmp(tmp_count) + 1
                endif
        end do

        do i = 0, count -1
                if ( tmp(i) .NE. chunk_size) then
                        result = result + 1
                endif
        end do


        if (result .EQ. 0) then
                crschk_do_schedule_static =  1
        else
                crschk_do_schedule_static =0
        endif

        end

