!***************************************************************************
! chk nest_testlock functions
!***************************************************************************

      integer function chk_omp_nest_testlock()
      USE OMP_LIB
                implicit none
                integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER  lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)

      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
      DO while(OMP_TEST_NEST_LOCK(LCK) .EQ. 0)
                end do
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      call omp_unset_nest_lock(lck)
      enddo
!$omp end do
!$omp end parallel
      call omp_destroy_nest_lock(lck)
!               print *, result, nr_iterations
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            chk_omp_nest_testlock=1
      else
            chk_omp_nest_testlock=0
      endif
      end

      integer function crschk_omp_nest_testlock()
      USE omp_lib
                implicit none
                integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)

      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      enddo
!$omp end do
!$omp end parallel
      call omp_destroy_nest_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            crschk_omp_nest_testlock=1
      else
            crschk_omp_nest_testlock=0
      endif
      end

