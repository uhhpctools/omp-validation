!********************************************************************
! Functions: chk_omp_atomic
!********************************************************************

        integer function chk_omp_atomic()
        implicit none
        integer i, sum, known_sum
        sum = 0
!$omp parallel
!$omp do
        do i=0, 999
!$omp atomic
          sum = sum + i
        end do
!$omp end parallel
        known_sum = 999*1000/2
        if ( known_sum .eq. sum ) then
          chk_omp_atomic = 1
        else
          chk_omp_atomic = 0
        end if
        end
        integer function crschk_omp_atomic()
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
        known_sum = 999*1000/2
        if ( known_sum .eq. sum) then
           crschk_omp_atomic = 1
        else
           crschk_omp_atomic = 0
        end if
        end

