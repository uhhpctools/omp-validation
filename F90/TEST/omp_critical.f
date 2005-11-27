!********************************************************************
! check and crosscheck CRITICAL, ATOMIC, BARRIER, FLUSH
! We use sleep in one thread to ensure the execution order of two threads
! which is not a good practice in OpenMP programming. Need to be fixed
! in future release.
! Functions: check_omp_critical
!********************************************************************

        integer function chk_omp_critical()
        implicit none
        integer i, sum, known_sum
        sum = 0
!$omp parallel
!$omp do
        do i =0, 999
!$omp critical
           sum = sum + i
!$omp end critical
        end do
!$omp end do
!$omp end parallel
        known_sum = 999*1000/2
        if ( known_sum .eq. sum ) then
          chk_omp_critical = 1
        else
          chk_omp_critical = 0
        end if
        end
        integer function crschk_omp_critical()
        implicit none
        integer i, sum, known_sum
        sum = 0
!$omp parallel
!$omp do
        do i=0, 999
         sum = sum + i
        end do
!$omp end do
!$omp end parallel
        known_sum = 999 * 1000/2
        if ( known_sum .eq. sum ) then
           crschk_omp_critical = 1
        else
           crschk_omp_critical = 0
        end if
        end

