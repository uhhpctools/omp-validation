!********************************************************************
! Functions: chk_do_ordered
!********************************************************************

        integer function chk_i_islarger(i)
        implicit none
        integer i, islarger, last_i
        integer common last_i
        if ( i .gt. last_i) then
          islarger = 1
        else
          islarger = 0
        end if
        last_i = i
        chk_i_islarger = islarger
        end

        integer function chk_do_ordered()
        implicit none
        integer sum, known_sum, i, my_islarger,is_larger,last_i
        integer chk_i_islarger
        integer common last_i
        sum = 0
        is_larger = 1
        last_i = 0
!$omp parallel private(my_islarger)
        my_islarger = 1
!$omp do schedule(static,1) ordered
        do i=1, 99
!$omp ordered
          if ( chk_i_islarger(i) .eq. 1 .and. my_islarger .eq. 1) then
            my_islarger = 1
          else
            my_islarger = 0
          end if
          sum = sum + i
!$omp end ordered
        end do
!$omp end do
!$omp critical
        if (is_larger .eq. 1 .and. my_islarger .eq. 1 ) then
          is_larger = 1
        else
          is_larger = 0
        end if
!$omp end critical
!$omp end parallel
        known_sum = (99*100)/2
        if ( known_sum .eq. sum .and. is_larger .eq. 1) then
          chk_do_ordered = 1
        else
          chk_do_ordered = 0
        end if
        end

        integer function crschk_do_ordered()
        implicit none
        integer sum, known_sum, i , my_islarger, is_larger, last_i
        integer chk_i_islarger
        integer common last_i
        sum = 0
        is_larger = 1
        last_i = 0
!$omp parallel private(my_islarger)
        my_islarger = 1
!$omp do schedule(static, 1)
        do i=1, 99
          if ( chk_i_islarger(i) .eq. 1 .and. my_islarger .eq. 1 ) then
            my_islarger = 1
          else
            my_islarger = 0
          end if
        end do
!$omp end do
!$omp critical
        if ( is_larger .eq. 1 .and. my_islarger .eq. 1 ) then
          is_larger = 1
        else
          is_larger = 0
        end if
!$omp end critical
!$omp end parallel
        known_sum = (99*100)/2
        if ( known_sum .eq. sum .and. is_larger .eq. 1 ) then
          crschk_do_ordered = 1
        else
          crschk_do_ordered = 0
        end if
        end

