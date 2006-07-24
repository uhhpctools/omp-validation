!********************************************************************
! Functions: chk_do_reduction
!********************************************************************

        integer function chk_do_reduction()
        implicit none
        integer sum, sum2, known_sum, i, i2
        include "omp_testsuite.f"
        sum = 0
        sum2 = 0
!$omp parallel
!$omp do schedule(dynamic, 1) reduction(+:sum)
        do i =1, LOOPCOUNT
          sum = sum + i
        end do
!$omp end do
!$omp end parallel

!$omp parallel
!$omp do schedule(static, 1) reduction (+: sum2)
        do i2=1, LOOPCOUNT
          sum2 = sum2 + i2
        end do
!$omp end do
!$omp end parallel
        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum .and. known_sum .eq. sum2 ) then
          chk_do_reduction = 1
        else
          chk_do_reduction = 0
        end if
        end

        integer function crschk_do_reduction()
        implicit none
        integer sum, sum2, known_sum, i, i2
        include "omp_testsuite.f"
        sum  = 0
        sum2 = 0
!$omp parallel
!$omp do schedule(dynamic, 1)
        do i=1, LOOPCOUNT
          sum = sum + i
        end do
!$omp end do
!$omp end parallel

!$omp parallel
!$omp do schedule(static, 1)
        do i2=1, LOOPCOUNT
          sum2 = sum2 + i2
        end do
!$omp end do
!$omp end parallel
        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum .and. known_sum .eq. sum2 ) then
          crschk_do_reduction = 1
        else
          crschk_do_reduction = 0
        end if
        end

