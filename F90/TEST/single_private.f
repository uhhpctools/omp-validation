!********************************************************************
! Functions: chk_single_private
!********************************************************************

        integer function chk_single_private()
        implicit none
        integer nr_threads_in_single, result, myresult, myit
        integer nr_iterations, i
        include "omp_testsuite.f"
        nr_threads_in_single=0
        result=0
        myresult=0
        myit=0
        nr_iterations=0
!$omp parallel private(i, myresult, myit)
        myresult = 0
        myit = 0
        do i=0, LOOPCOUNT -1

!$omp single private(nr_threads_in_single)
          nr_threads_in_single = 0
!$omp flush
          nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
          myit = myit + 1
          nr_threads_in_single = nr_threads_in_single - 1
          myresult = myresult + nr_threads_in_single
!$omp end single nowait
        end do
!$omp critical
        result = result + myresult
        nr_iterations = nr_iterations + myit
!$omp end critical
!$omp end parallel
        if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT) then
           chk_single_private = 1
        else
           chk_single_private = 0
        end if
        end

        integer function crschk_single_private()
        implicit none
        integer nr_threads_in_single, result, myresult, myit
        integer nr_iterations, i
        include "omp_testsuite.f"
        nr_threads_in_single =0
        result=0
        myresult=0
        myit=0
        nr_iterations=0
!$omp parallel private(i,myresult, myit)
        myresult = 0
        myit = 0
        do i = 0, LOOPCOUNT -1
!$omp single
          nr_threads_in_single = 0
!$omp flush
          nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
          myit = myit + 1
          nr_threads_in_single = nr_threads_in_single - 1
          myresult = myresult + nr_threads_in_single
!$omp end single nowait
        end do
!$omp critical
        result = result + myresult
        nr_iterations = nr_iterations + myit
!$omp end critical
!$omp end parallel
        if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT) then
           crschk_single_private = 1
        else
           crschk_single_private = 0
        endif
        end

