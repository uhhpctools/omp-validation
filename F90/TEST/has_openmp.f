!*********************************************************************
! Functions: check_has_omp
!
! Testing if the conditional compilation is supported or not.
!
!Yi Wen at 05032004: Do we want to write two versions of has_omp?
!both C23456789 and #ifdef formats are supposed to work.
!At least Sun's compiler cannot deal with the second format (#ifdef)
!
!Modified by Chunhua Liao
!Date: May 2005
!*********************************************************************
        integer function chk_has_OpenMP()
         chk_has_OpenMP=0
!version 1.
!C23456789 
!$       chk_has_OpenMP=1


! version 2.
!#ifdef _OPENMP
!        chk_has_OpenMP=1
!#endif
        end

        integer function crschk_has_OpenMP()
        crschk_has_OpenMP=0
!version 1.
!        crschk_has_OpenMP=1

! version 2.
!#ifdef _OPENMP
!        crschk_has_OpenMP=1
!#endif
        end

