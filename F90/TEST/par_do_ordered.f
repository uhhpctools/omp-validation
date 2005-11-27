!********************************************************************
! Functions: chk_par_do_ordered
!********************************************************************

	integer function chk_i_islarger2(i)
        implicit none
        integer i
        common last_i
	integer last_i,islarger
        include "omp_testsuite.f"
!        print *, "last_i",last_i, "i", i
! last_i is a global variable
	if ( i .gt. last_i ) then
	  islarger = 1
	else
	  islarger = 0
	end if
	last_i = i
	chk_i_islarger2 = islarger
	end

	integer function chk_par_do_ordered()
        implicit none
        common last_i
	integer sum, known_sum,i, is_larger,last_i
	integer chk_i_islarger2
	
	sum=0
	is_larger=1
	last_i=0
!$omp parallel do schedule(static, 1) ordered
	do i=1, 99
!$omp ordered
	  if( chk_i_islarger2(i) .eq. 1 .and. is_larger .eq. 1 ) then	  
	    is_larger = 1
	  else
	    is_larger = 0
	  end if
	  sum = sum + i
!$omp end ordered
	end do
!$omp end parallel do
	known_sum = (99*100)/2
!Yi Wen; Sun compiler will fail sometimes
!        print *, "sum", sum, "ks", known_sum, "la", is_larger
	if ( known_sum .eq. sum .and. is_larger .eq. 1 ) then
	   chk_par_do_ordered = 1
	else
	   chk_par_do_ordered = 0
	end if
	end

	integer function crschk_par_do_ordered()
        implicit none
	integer sum,known_sum, i, is_larger, last_i
	integer chk_i_islarger2
	common last_i
	sum=0
	is_larger=1
	last_i=0
!$omp parallel do schedule(static, 1) 
	do i=1, 99
	  if( chk_i_islarger2(i) .eq. 1 .and. is_larger .eq. 1) then
            is_larger = 1
          else
            is_larger = 0
          end if
          sum = sum + i
	end do
!$omp end parallel do
	known_sum = (99*100)/2
	if ( known_sum .eq. sum .and. is_larger .eq. 1) then
	   crschk_par_do_ordered = 1
	else
	   crschk_par_do_ordered = 0
	end if
	end 

