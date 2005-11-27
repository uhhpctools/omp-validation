!********************************************************************
! Functions: chk_single_copyprivate
!********************************************************************

      integer function chk_single_copyprivate(fileunit)
      implicit none
      integer result
      integer fileunit
      integer nr_iterations
      integer i
      integer j,thread
      integer omp_get_thread_num
      include "omp_testsuite.f"
      result=0
      nr_iterations=0
!$omp parallel private(i,j,thread)
      do i=0,LOOPCOUNT-1
	thread=omp_get_thread_num()
!$omp single 
	nr_iterations=nr_iterations+1
	j=i
!$omp end single copyprivate(j)
!$omp critical
       result=result+j-i;
!$omp end critical

       end do
!$omp end parallel
       if(result .eq. 0 .AND. 
     x  nr_iterations .eq. LOOPCOUNT) then
          chk_single_copyprivate=1
       else
          chk_single_copyprivate=0
       endif
       end


      integer function crschk_single_copyprivate(fileunit)
      implicit none
      integer result
      integer nr_iterations
      integer fileunit
      integer i
      integer j,thread
      integer omp_get_thread_num
      include "omp_testsuite.f"
      result=0
      nr_iterations=0
!$omp parallel private(i,j,thread)
      do i=0,LOOPCOUNT-1
	thread=omp_get_thread_num()
!$omp single 
	nr_iterations=nr_iterations+1
	j=i
!$omp end single
!$omp critical
       result=result+j-i;
!$omp end critical

       end do
!$omp end parallel
       if(result .eq. 0 .AND. 
     x  nr_iterations .eq. LOOPCOUNT) then
          crschk_single_copyprivate=1
       else
          crschk_single_copyprivate=0
       endif
       end


