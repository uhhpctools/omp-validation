!********************************************************************
! Functions: check_parallel_section_lastprivate
!********************************************************************

	integer function chk_par_section_lastprivate()
        implicit none
	integer sum, sum0, known_sum, i ,i0
	sum =0
	sum0 = 0
	i0 = -1
!$omp parallel sections lastprivate(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
          i0=i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
          i0 = i
	end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
          i0 = i
	end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = (999*1000)/2
!        print *, "sum", sum, "ks", known_sum, i0
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	  chk_par_section_lastprivate = 1
	else
	  chk_par_section_lastprivate = 0
	end if
	end

	integer function crschk_par_section_lastprivate()
        implicit none
	integer sum, sum0, known_sum, i ,i0
	sum =0
	sum0 = 0
	i0 = -1
!$omp parallel sections private(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	end do
	i0 = i
!$omp critical
	sum0 = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
	end do
        i0 = i
!$omp critical
        sum0 = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
	end do
        i0 = i
!$omp critical
        sum0 = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = (999*1000)/2
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	  crschk_par_section_lastprivate = 1
	else
	  crschk_par_section_lastprivate = 0
	end if
	end

