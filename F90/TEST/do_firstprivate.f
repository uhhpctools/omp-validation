!********************************************************************
! Functions: chk_do_firstprivate
!********************************************************************
      integer function chk_do_firstprivate()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel firstprivate(sum1)
!$omp do firstprivate(sum0)
      do i=1,LOOPCOUNT
        sum0 = sum0 + i
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
         chk_do_firstprivate = 1
      else
         chk_do_firstprivate = 0
      end if
      end

        integer function crschk_do_firstprivate()
        implicit none
        integer sum, sum0, sum1, known_sum, i
        include "omp_testsuite.f"
        sum = 0
        sum0 = 0
        sum1 = 0

!$omp parallel firstprivate(sum1)
!$omp do
        do i=1,LOOPCOUNT
          sum0 = sum0 + i
          sum1 = sum0
        end do
!$omp end do
!$omp critical
        sum = sum + sum1
!$omp end critical
!$omp end parallel
        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum ) then
          crschk_do_firstprivate = 1
        else
          crschk_do_firstprivate = 0
        end if
        end

