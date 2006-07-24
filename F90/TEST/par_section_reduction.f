!**********************************************************
!par_section_reduction
!
!By: Chunhua Liao, University of Houston
!Date: May 9, 2005
!************************************************************
	integer function chk_par_section_reduction(logfile)

	implicit none
	include "omp_testsuite.f"

	character logfile*50
	integer sum
	integer known_sum
	double precision dtp,dsum/0.0/
	double precision dknown_sum
	double precision dt/0.5/
	double precision rounding_error/1.E-9/
	integer diff
	double precision ddiff
	integer product/1/
	integer know_product
	integer logic_and/1/
	integer bit_and/1/
	integer logic_or/0/
	integer bit_or/0/
	integer exlusive_bit_or/0/
	integer logics(1000)
	integer i
	integer errors/0/

	sum=0
	known_sum=(999*1000)/2
!	known_sum=(999*1000)/2+7 ! should not add 7, by Liao

!$omp parallel sections private(i) reduction (+:sum)
!$omp section
	do i=1,299
	  sum=sum+i
	end do
!$omp section
        do i=300,699
          sum=sum+i     
        end do

!$omp section
        do i=700,999
          sum=sum+i     
        end do
!$omp end parallel sections

	if(known_sum .NE. sum) then
	   errors= errors + 1
	   write(1,*) "Error in sum with integer:Result was",sum,
     & "instead of",known_sum
	end if

! check - operation
        diff=(999*1000)/2
!$omp parallel sections private(i) reduction (-:diff)
!$omp section
        do i=1,299
          diff=diff-i     
        end do
!$omp section
        do i=300,699
          diff=diff-i     
        end do

!$omp section
        do i=700,999
          diff=diff-i     
        end do
!$omp end parallel sections
        if(diff .NE. 0) then     
           errors= errors + 1   
           write(1,*) "Error in Difference with integer:Result was",diff       
        end if  

! return result
	if (errors .eq. 0) then
	  chk_par_section_reduction=1
	else
	  chk_par_section_reduction=0
	end if
	end function chk_par_section_reduction

!*************************************************
! Crosscheck
!*************************************************
	integer function crschk_par_section_reduction(logfile)

	implicit none
	include "omp_testsuite.f"

	character logfile*50
	integer sum
	integer known_sum
	double precision dtp,dsum/0.0/
	double precision dknown_sum
	double precision dt/0.5/
	double precision rounding_error/1.E-9/
	integer diff
	double precision ddiff
	integer product/1/
	integer know_product
	integer logic_and/1/
	integer bit_and/1/
	integer logic_or/0/
	integer bit_or/0/
	integer exlusive_bit_or/0/
	integer logics(1000)
	integer i
	integer errors
 
        errors =0
	sum=0  ! ensure sum reset to 0 each time

	known_sum=(999*1000)/2
!$omp parallel sections private(i)
!$omp section
	do i=1,299
	  sum=sum+i
	end do
!$omp section
        do i=300,699
          sum=sum+i     
        end do

!$omp section
        do i=700,999
          sum=sum+i     
        end do
!$omp end parallel sections

	if(known_sum .NE. sum) then
	   errors= errors + 1
!	   write(1,*) "Cross check: Error in sum with integer:Result was",sum,
!     & "instead of",known_sum
	end if

! check - operation
        diff=(999*1000)/2
!$omp parallel sections private(i) 
!$omp section
        do i=1,299
          diff=diff-i     
        end do
!$omp section
        do i=300,699
          diff=diff-i     
        end do

!$omp section
        do i=700,999
          diff=diff-i     
        end do
!$omp end parallel sections
        if(diff .NE. 0) then     
           errors= errors + 1   
!           write(1,*) "Error in Difference with integer:Result was",diff  
!     &  ,"with error number=",errors     
        end if  

! return result, if no errors, crosscheck accidently passed the test
	if (errors .EQ. 0) then
	  crschk_par_section_reduction=1
	else
	  crschk_par_section_reduction=0
	end if
	end function crschk_par_section_reduction
