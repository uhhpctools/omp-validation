!********************************************************************
! Functions: chk_section_firstprivate
!********************************************************************
        integer function chk_section_firstprivate()
        implicit none
        integer sum, sum0, known_sum
        sum = 7
        sum0 = 11
!$omp parallel
!$omp sections firstprivate(sum0)
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
        known_sum = 11*3+7
        if ( known_sum .eq. sum) then
          chk_section_firstprivate = 1
        else
          chk_section_firstprivate = 0
        end if
        end

        integer function crschk_section_firstprivate()
        implicit none
        integer sum, sum0, known_sum
        sum = 7
        sum0 = 11
!$omp parallel
!$omp sections private(sum0)
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
        known_sum=11*3+7
        if ( known_sum .eq. sum) then
          crschk_section_firstprivate = 1
        else
          crschk_section_firstprivate = 0
        end if
        end


