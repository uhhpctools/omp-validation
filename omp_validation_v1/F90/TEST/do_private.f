!********************************************************************
! Functions: chk_do_private
!********************************************************************

        subroutine do_some_work()
        implicit none
        real i
!Yi Wen modified here, f90
        intrinsic sqrt
        double precision sum
        include "omp_testsuite.f"
        sum = 0.0
        do i=0.0, LOOPCOUNT-1,1.0
          sum = sum + sqrt(i)
        end do
        end

      integer function chk_do_private()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel private(sum1)
      sum0 = 0
      sum1 = 0
!$omp do private(sum0) schedule(static,1)
!Yi Wen modified: 05032004
      do i=1, LOOPCOUNT
         sum0=sum1
!$omp flush
        sum0 = sum0 + i
        call do_some_work()
!$omp flush
!        print *, sum0
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel

      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
!        print *, "sum:", sum, "known_sum", known_sum
      if ( known_sum .eq. sum) then
        chk_do_private = 1
      else
        chk_do_private = 0
      end if
      end

      integer function crschk_do_private()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel private(sum1)
      sum0 = 0
      sum1 = 0
!$omp do schedule(static,1)
      do i=1,LOOPCOUNT
        sum0 = sum1
!$omp flush
        sum0 = sum0 + i
        call do_some_work()
!$omp flush
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
        crschk_do_private = 1
      else
        crschk_do_private = 0
      endif
      end

