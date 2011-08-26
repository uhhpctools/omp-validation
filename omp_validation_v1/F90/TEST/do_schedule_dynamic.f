!********************************************************************
! Functions: chk_do_schedule_dynamic
!********************************************************************

        integer function chk_do_schedule_dynamic(logfile)
        implicit none
        integer CFDMAX_SIZE
        integer omp_get_thread_num,omp_get_num_threads
        character*20 logfile
        integer chunk_size
        integer threads
        integer count, tmp_count
        integer,allocatable:: tmp(:)
        integer i, ii
        integer result
        parameter (CFDMAX_SIZE = 1000)
        integer tids(0:CFDMAX_SIZE-1), tid
        chunk_size = 7
        count = 0
        tmp_count = 0
        result = 0
        ii = 0
!$omp parallel 
        tid = omp_get_thread_num()
!$omp do schedule(dynamic,chunk_size)
        do i=0, CFDMAX_SIZE-1
          tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i=0, CFDMAX_SIZE - 2
          if ( tids(i) .ne. tids(i+1) ) then
            count = count + 1
          end if
        end do
 
        allocate( tmp(0:count) )
        tmp(0) = 1
 
        do i=0, CFDMAX_SIZE - 2
           if ( tmp_count .gt. count ) then
             write(*,*) "--------------------"
             write(*,*) "Testinternal Error: List too small!!!"
             write(*,*) "--------------------"
             goto 10
           end if
           if ( tids(i) .ne. tids(i+1) ) then
             tmp_count = tmp_count + 1
             tmp(tmp_count) = 1
           else
             tmp(tmp_count) = tmp(tmp_count) +1
           end if 
         end do          

!... is dynamic statement working? 

 10        do i=0, count -1
           if ( mod(tmp(i),chunk_size) .ne. 0 ) then
! ... it is possible for 2 adjacent chunks assigned to a same thread 
             result = result + 1
             write(1,*) "The intermediate dispatch has wrong chunksize."
           end if
          end do

          if ( mod(tmp(count), chunk_size) .ne. 
     &          mod (CFDMAX_SIZE, chunk_size) ) then
             result = result + 1
             write(1,*) "the last dispatch has wrong chunksize."
          end if
         
         if ( result .eq. 0) then
          chk_do_schedule_dynamic = 1
         else
          chk_do_schedule_dynamic = 0
         end if
        end

        integer function crschk_do_schedule_dynamic(logfile)
        implicit none
        character*20 logfile
        integer CFDMAX_SIZE
        integer omp_get_thread_num,omp_get_num_threads
        integer chunk_size
        integer threads
        integer count, tmp_count
        integer,allocatable:: tmp(:)
        integer i, ii
        integer result
        parameter (CFDMAX_SIZE = 1000)
        integer tids(0:CFDMAX_SIZE-1), tid
        chunk_size = 7
        count = 0
        tmp_count = 0
        result = 0
        ii = 0
!$omp parallel 
        tid = omp_get_thread_num()
!$omp do 
        do i=0, CFDMAX_SIZE-1
          tids(i) = tid
        end do
!$omp end do
!$omp end parallel

        do i=0, CFDMAX_SIZE - 2
          if ( tids(i) .ne. tids(i+1) ) then
            count = count + 1
          end if
        end do
 
        allocate( tmp(0:count) )
        tmp(0) = 1
 
        do i=0, CFDMAX_SIZE - 2
           if ( tmp_count .gt. count ) then
             write(*,*) "--------------------"
             write(*,*) "Testinternal Error: List too small!!!"
             write(*,*) "--------------------"
             goto 10
           end if
           if ( tids(i) .ne. tids(i+1) ) then
             tmp_count = tmp_count + 1
             tmp(tmp_count) = 1
           else
             tmp(tmp_count) = tmp(tmp_count) +1
           end if 
         end do          

!... is dynamic statement working? 

 10        do i=0, count -1
           if ( mod(tmp(i),chunk_size) .ne. 0 ) then
! ... it is possible for 2 adjacent chunks assigned to a same thread 
             result = result + 1
             write(1,*) "The intermediate dispatch has wrong chunksize."
           end if
          end do

          if ( mod(tmp(count), chunk_size) .ne. 
     &          mod (CFDMAX_SIZE, chunk_size) ) then
             result = result + 1
             write(1,*) "the last dispatch has wrong chunksize."
          end if
         
         if ( result .eq. 0) then
          crschk_do_schedule_dynamic = 1
         else
          crschk_do_schedule_dynamic = 0
         end if
        end 
