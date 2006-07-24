!Yi Wen at 05032004: all functions are added with "implicit none"
!********************************************************************
! Functions: chk_section_reduction
!********************************************************************

        integer function chk_section_reduction()
        implicit none
        integer sum, known_sum, i
        sum = 7
!$omp parallel
!$omp sections reduction(+:sum) private(i)
!$omp section
        do i=1, 399
          sum = sum + i
        end do
!$omp section
        do i=400, 699
          sum = sum + i
        end do
!$omp section
        do i=700, 999
          sum = sum + i
        end do
!$omp end sections
!$omp end parallel
        known_sum = (999*1000)/2+7
        if ( known_sum .eq. sum) then
          chk_section_reduction = 1
        else
          chk_section_reduction = 0
        end if
        end

        integer function crschk_section_reduction()
        implicit none
        integer sum, known_sum, i
        sum = 7
!$omp parallel
!$omp sections private(i)
!$omp section
        do i=1, 399
          sum = sum + i
        end do
!$omp section
        do i=400, 699
          sum = sum + i
        end do
!$omp section
        do i=700, 999
          sum = sum + i
        end do
!$omp end sections
!$omp end parallel
        known_sum=(999*1000)/2+7
        if (known_sum .eq. sum) then
           crschk_section_reduction = 1
        else
           crschk_section_reduction = 0
        end if
        end

