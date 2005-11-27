!*********************************************************************
! Functions: chk_omp_in_parallel()
!*********************************************************************

        integer function chk_omp_in_parallel()
C   checks that false is returned when called from serial region
C     and true is returned when called within parallel region
        logical serial, parallel, omp_in_parallel
        serial=.TRUE.
        parallel=.FALSE.
        serial=omp_in_parallel()
!$omp parallel
!$omp single
      parallel=omp_in_parallel();
!$omp end single
!$omp end parallel
      if( .not. serial .and. parallel ) then
       chk_omp_in_parallel=1
      else
       chk_omp_in_parallel=0
      end if
      end
      integer function crschk_omp_in_parallel()

        logical serial, parallel, omp_in_parallel
        serial=.TRUE.
        parallel=.FALSE.
!       serial=omp_in_parallel()
!$omp parallel
!$omp single
!      parallel=omp_in_parallel();
!$omp end single
!$omp end parallel
      if( .not. serial .and. parallel ) then
       crschk_omp_in_parallel=1
      else
       crschk_omp_in_parallel=0
      end if
      end

