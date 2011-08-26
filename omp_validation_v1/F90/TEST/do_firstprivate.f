!********************************************************************
! Functions: chk_do_firstprivate
!********************************************************************
      integer function chk_do_firstprivate()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      integer numthreads
      integer omp_get_num_threads
      include "omp_testsuite.f"
      sum = 0
      sum0 = 12345 ! bug 162, Liao
      sum1 = 0
!$omp parallel firstprivate(sum1)
!$omp single
      numthreads= omp_get_num_threads()
!$omp end single
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
      known_sum =12345*numthreads+ (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
         chk_do_firstprivate = 1
      else
         chk_do_firstprivate = 0
      end if
      end

        integer function crschk_do_firstprivate()
        implicit none
        integer sum, sum0, sum1, known_sum, i
        integer numthreads
        integer omp_get_num_threads
        include "omp_testsuite.f"
        sum = 0
        sum0 = 12345
        sum1 = 0

!$omp parallel firstprivate(sum1)
!$omp single
      numthreads= omp_get_num_threads()
!$omp end single

!$omp do private(sum0)
        do i=1,LOOPCOUNT
          sum0 = sum0 + i
          sum1 = sum0
        end do
!$omp end do
!$omp critical
        sum = sum + sum1
!$omp end critical
!$omp end parallel
!bug 162, by Liao
        known_sum = 12345*numthreads+ (LOOPCOUNT*(LOOPCOUNT+1))/2
        if ( known_sum .eq. sum ) then
          crschk_do_firstprivate = 1
        else
          crschk_do_firstprivate = 0
        end if
        end

