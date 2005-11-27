!***************************************************************************
!   omp_chk_locks.f: an implementation for checking if compilers
!   implement OMP lock functions correctly
!***************************************************************************
      integer function chk_omp_lock()
      USE omp_lib
                implicit none
                integer result
!lock variable
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_threads_in_single
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      call omp_init_lock(lck)
      nr_iterations=0
      nr_threads_in_single=0
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
           call omp_set_lock(lck)
!$omp flush
           nr_threads_in_single=nr_threads_in_single+1
!$omp flush
           nr_iterations=nr_iterations+1
           nr_threads_in_single=nr_threads_in_single-1
           result=result+nr_threads_in_single
           call omp_unset_lock(lck)
      enddo
!$omp end do
!$omp end parallel
      call omp_destroy_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            chk_omp_lock=1
      else
            chk_omp_lock=0
      endif
      end

      integer function crschk_omp_lock()
      USE omp_lib
                implicit none
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
                integer result
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_lock(lck)

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
      call omp_destroy_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
!                     print *, "cross ckeck : 1"
            crschk_omp_lock=1
      else
!                     print *, "cross ckeck : 0"
            crschk_omp_lock=0
      endif
      end

