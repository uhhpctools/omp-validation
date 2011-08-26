!********************************************************************
! Functions: chk_omp_nested
!   Test if the compiler support nested parallelism
!   By Chunhua Liao, University of Houston
!     Oct. 2005
!********************************************************************
        integer function chk_omp_nested()
!        USE OMP_LIB
        implicit none
        integer counter
        include "omp_testsuite.f"

        counter =0
        
!$      CALL OMP_SET_NESTED(.TRUE.)
!#ifdef _OPENMP
!       CALL OMP_SET_NESTED(.TRUE.) 
!#endif

!$omp parallel
!$omp critical
        counter = counter + 1
!$omp end critical

!$omp parallel
!$omp critical
        counter = counter - 1
!$omp end critical
!$omp end parallel

!$omp end parallel
        
        if (counter .eq.0 ) then
           chk_omp_nested = 0
        else
           chk_omp_nested = 1
        end if 
        end

!********************************************************************
! Functions: crschk_omp_nested
!********************************************************************
        integer function crschk_omp_nested()
!        USE OMP_LIB
        implicit none
        integer counter
        include "omp_testsuite.f"

        counter =0

!$      CALL OMP_SET_NESTED(.FALSE.)
!#ifdef _OPENMP
!       CALL OMP_SET_NESTED(.FALSE.)
!#endif

!$omp parallel
!$omp critical
        counter = counter + 1
!$omp end critical

!$omp parallel
!$omp critical
        counter = counter - 1
!$omp end critical
!$omp end parallel

!$omp end parallel

        if (counter .eq.0 ) then
           crschk_omp_nested = 0
        else
           crschk_omp_nested = 1
        end if
        end

