        subroutine do_some_work3()
        real i
! Yi Wen modified here
        intrinsic sqrt
        double precision sum
        include "omp_testsuite.f"
        sum = 0.0
        do i=0.0, 1000000-1, 1.0
          sum = sum + sqrt(i)
        end do
        end

!********************************************************************
! Functions: chk_omp_barrier
!********************************************************************

        integer function chk_omp_barrier()
!        use omp_lib
        implicit none
        integer omp_get_thread_num
        integer result1, result2, rank
        result1 = 0
        result2 = 0
!Yi modified here 05042004: privatize rank by sementics
!$omp parallel private(rank)
        rank = omp_get_thread_num()
!        print *, "rank", rank
        if ( rank .eq. 1 ) then
!Yi modified here 05042004
          call sleep(2)
          result2 = 3
        end if
!$omp barrier
        if ( rank .eq. 0 ) then
          result1 = result2
        end if
!$omp end parallel
        if ( result1 .eq. 3 ) then
           chk_omp_barrier = 1
        else
           chk_omp_barrier = 0
        end if
        end
        integer function crschk_omp_barrier()
!        use omp_lib
        implicit none
        integer result1, result2, rank
        integer omp_get_thread_num
        result1 = 0
        result2 = 0
!Yi at 05042004 made the same modification as in chk_omp_barrier
!$omp parallel private(rank)
        rank = omp_get_thread_num()
        if ( rank .eq. 1 ) then
          call sleep(2)
          result2 = 3
        end if
        if ( rank. eq. 0 ) then
          result1 = result2
        end if
!$omp end parallel
        if ( result1 .eq. 3 ) then
           crschk_omp_barrier = 1
        else
           crschk_omp_barrier = 0
        end if
        end

