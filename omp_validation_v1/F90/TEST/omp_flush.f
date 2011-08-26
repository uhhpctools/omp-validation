!********************************************************************
! Functions: chk_omp_flush
!********************************************************************

        integer function chk_omp_flush()
!        use omp_lib
        implicit none
        integer result1, result2, dummy, rank
        integer omp_get_thread_num
!Yi modefied at 05042004
        result1=0
        result2=0
!$omp parallel private(rank)
        rank = omp_get_thread_num()
!$omp barrier
        if ( rank .eq. 1 ) then
          result2 = 3
!$omp flush(result2)
          dummy = result2
        end if
        if ( rank .eq. 0 ) then
          call sleep(1)
!$omp flush(result2)
          result1 = result2
        end if
!$omp end parallel
!        print *,"1:", result1, "2:", result2, "dummy", dummy
        if ( result1 .eq. result2 .and. result2 .eq. dummy .and.
     &       result2 .eq. 3 ) then
           chk_omp_flush = 1
        else
           chk_omp_flush = 0
        end if
        end

        integer function crschk_omp_flush()
!        use omp_lib
        implicit none
        integer result1, result2, dummy, rank
        integer  omp_get_thread_num
        result1 = 0
        result2 = 0
!Yi modified at 05042004
!$omp parallel private(rank)
        rank = omp_get_thread_num()
!       print *, "rank", rank
!$omp barrier
        if ( rank .eq. 1 ) then
          result2 = 3
          dummy = result2
          call sleep(2)
        enD If
        if ( rank .eq. 0) then
          call sleep(1)
          result1 = result2
        end if
!$omp end parallel
        if ( result1 .eq. result2 .and. result2 .eq. dummy .and.
     &       result2 .eq. 3 ) then
            crschk_omp_flush = 1
        else
             crschk_omp_flush = 0
        end if
        end

