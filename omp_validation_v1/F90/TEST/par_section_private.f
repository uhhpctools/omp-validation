!********************************************************************
! Functions: chk_par_section_private
!********************************************************************

	integer function chk_par_section_private()
        implicit none
	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel sections private(sum0,i)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	end do
!$omp critical
	  sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
        end do
!$omp critical
          sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
        end do
!$omp critical
          sum = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum ) then
	   chk_par_section_private = 1
	else
	   chk_par_section_private = 0
	end if
	end 

	integer function crschk_par_section_private()
        implicit none
	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel sections private(i)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum ) then
	  crschk_par_section_private = 1
	else
	  crschk_par_section_private = 0
	end if
	end

