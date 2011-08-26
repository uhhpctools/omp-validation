!********************************************************************
! Functions: chk_par_section_firstprivate
!********************************************************************

	integer function chk_par_section_firstprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel sections firstprivate(sum0)
!$omp section
!$omp critical 
	sum = sum + sum0
!$omp end critical
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = 11*3 + 7
	if ( known_sum .eq. sum ) then
	  chk_par_section_firstprivate = 1
	else
	  chk_par_section_firstprivate = 0
	end if
	end 

	integer function crschk_par_section_firstprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel sections private(sum0)
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
!$omp end parallel sections
	known_sum = 11*3 + 7
	if ( known_sum .eq. sum ) then
	  crschk_par_section_firstprivate = 1
	else
	  crschk_par_section_firstprivate = 0
	end if
	end

