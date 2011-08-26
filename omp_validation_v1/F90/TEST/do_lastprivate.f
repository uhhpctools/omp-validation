
!********************************************************************
! Functions: chk_do_lastprivate
!*******************************************************************

        integer function chk_do_lastprivate()
        implicit none
        integer sum, sum0, known_sum, i, i0
        include "omp_testsuite.f"
        sum = 0
        sum0 = 0
        i0 = -1
!$omp parallel firstprivate(sum0)
!$omp do schedule(static,7) lastprivate(i0)
        do i=1, LOOPCOUNT
          sum0 = sum0 + i
          i0 = i
        end do
!$omp end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel
        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
           chk_do_lastprivate = 1
        else
           chk_do_lastprivate = 0
        end if
        end

        integer function crschk_do_lastprivate()
        implicit none
        integer sum, sum0, known_sum, i, i0
        include "omp_testsuite.f"
        sum = 0
        sum0 = 0
        i0 = -1
!$omp parallel firstprivate(sum0)
!$omp do schedule(static, 7)
        do i=1, LOOPCOUNT
           sum0 = sum0 + i
           i0 = i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel
        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
          crschk_do_lastprivate = 1
        else
          crschk_do_lastprivate = 0
        end if
        end


