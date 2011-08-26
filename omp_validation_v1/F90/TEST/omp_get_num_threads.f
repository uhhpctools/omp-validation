!*********************************************************************
! Functions: check_omp_get_num_threads()
!*********************************************************************

        integer function chk_omp_get_num_threads()
        integer  nthreads, nthreads_lib
        integer omp_get_num_threads
        nthreads=0
        nthreads_lib=-1
!$omp parallel
!shared(nthreads,nthreads_lib)
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
!$omp single
        nthreads_lib=omp_get_num_threads()
!$omp end single
!$omp end parallel
        if(nthreads .eq. nthreads_lib) then
          chk_omp_get_num_threads = 1
        else
          chk_omp_get_num_threads = 0
        end if
        end
        integer function crschk_omp_get_num_threads()
        integer  nthreads, nthreads_lib
        nthreads=0
        nthreads_lib=-1
!$omp parallel
!shared(nthreads,nthreads_lib)
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
!!$omp single
!        nthreads_lib=omp_get_num_threads()
!!$omp end single
!$omp end parallel
        if(nthreads .eq. nthreads_lib) then
          crschk_omp_get_num_threads = 1
        else
          crschk_omp_get_num_threads = 0
        end if
        end

