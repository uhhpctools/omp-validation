!********************************************************************
! Functions: chk_omp_copyin
!********************************************************************

        integer function chk_omp_copyin()
        implicit none
        integer sum, known_sum, i
!Yi Wen at 05042004 modified to add "save" for sum1 and
!commented the below common block
        integer, save::sum1
!       common/csum1/ sum1
!!!!!!!$omp threadprivate(/csum1/)
!$omp threadprivate(sum1)
        sum = 0
        sum1 = 0
!$omp parallel copyin(sum1)
!        print *,"sum1",sum1
!$omp do
        do i=1, 999
          sum1 = sum1 + i
        end do
!$omp critical
        sum = sum + sum1
!$omp end critical
!$omp end parallel
        known_sum = 999*1000/2
        if ( known_sum .eq. sum ) then
           chk_omp_copyin = 1
        else
           chk_omp_copyin = 0
        end if
        end

        integer function crschk_omp_copyin()
        implicit none
        integer sum, known_sum, i
!Yi Wen at 05042004, same modification
        integer, save::crosssum1
!       common/ccrosssum1/ crosssum1
!!!!!!!!$omp threadprivate(/ccrosssum1/)
!$omp threadprivate(crosssum1)
        sum = 0
        crosssum1 = 789
!$omp parallel
!       print *,"cs",crosssum1
!$omp do
        do i=1, 999
          crosssum1 = crosssum1 + i
        end do
!$omp end do
!$omp critical
        sum = sum + crosssum1
!$omp end critical
!$omp end parallel
        known_sum = 999*1000/2
        if ( known_sum .eq. sum ) then
            crschk_omp_copyin = 1
        else
            crschk_omp_copyin = 0
        end if
        end

