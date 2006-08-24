!********************************************************************
! Functions: chk_par_do_reduction
!********************************************************************

!        integer function chk_do_reduction(logFile)
        integer function chk_par_do_reduction()
        implicit none
        integer sum, sum2, known_sum, i, i2,diff
        integer product,known_product,int_const
        integer MAX_FACTOR
        double precision dsum,dknown_sum,dt,dpt
        double precision rounding_error, ddiff
        integer double_DIGITS
        logical logic_and, logic_or, logic_eqv,logic_neqv
        integer bit_and, bit_or
        integer exclusiv_bit_or
        integer min_value, max_value
        double precision dmin, dmax
        integer result
        include "omp_testsuite.f"
        logical logics(LOOPCOUNT)
        integer int_array(LOOPCOUNT)
        double precision d_array(LOOPCOUNT)
        parameter (int_const=10,known_product=3628800)
        parameter (double_DIGITS=20,MAX_FACTOR=10)
        parameter (rounding_error=1.E-6)
        dt = 1./3.
        known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2
        product = 1
        sum2 = 0
        sum = 0
        dsum = 0.
        result =0 
        logic_and = .true.
        logic_or = .false.
        bit_and = 1
        bit_or = 0
        exclusiv_bit_or = 0
!$omp parallel do schedule(dynamic, 1) reduction(+:sum)
        do i =1, LOOPCOUNT
          sum = sum + i
        end do
!$omp end parallel do

        if (known_sum .ne. sum) then
             result = result + 1
        write(1,*) "Error in sum with integers: Result was ",
     &   sum,"instead of ", known_sum
        end if

        diff = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2



!$omp parallel do schedule(dynamic, 1) reduction (-: diff)
        do i =1, LOOPCOUNT
          diff = diff - i
        end do
!$omp end parallel do
  
        if ( diff .NE. 0 ) then
          result = result + 1
        write(1,*) "Error in difference with integers: Result was ",
     &   sum,"instead of 0."
        end if

!... Test for doubles
        dsum =0.
        dpt = 1

        do i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        end do
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel do schedule(dynamic,1) reduction(+:dsum)
        do i=0,DOUBLE_DIGITS-1
              dsum = dsum + dt**i
        end do
!$omp end parallel do

 
        if(dsum .ne. dknown_sum .and. 
     &     abs(dsum - dknown_sum) .gt. rounding_error ) then
           result = result + 1
           write(1,*) "Error in sum with doubles: Result was ",
     &       dsum,"instead of ",dknown_sum,"(Difference: ",
     &       dsum - dknown_sum,")"
        end if
        dpt = 1


      
        do i=1, DOUBLE_DIGITS
           dpt = dpt*dt
        end do
        ddiff = ( 1-dpt)/(1-dt)
!$omp parallel do schedule(dynamic,1) reduction(-:ddiff)
        do i=0, DOUBLE_DIGITS-1
          ddiff = ddiff - dt**i
        end do
!$omp end parallel do

        if ( abs(ddiff) .GT. rounding_error ) then
           result = result + 1
           write(1,*) "Error in Difference with doubles: Result was ",
     &       ddiff,"instead of 0.0"
        end if

!$omp parallel do schedule(dynamic,1) reduction(*:product)
        do i=1,MAX_FACTOR
           product = product * i
        end do
!$omp end parallel do

        if (known_product .NE. product) then
           result = result + 1
           write(1,*) "Error in Product with integers: Result was ",
     &       product," instead of",known_product 
        end if

        do i=1,LOOPCOUNT
          logics(i) = .true.
        end do

!$omp parallel do schedule(dynamic,1) reduction(.and.:logic_and)
        do i=1,LOOPCOUNT
          logic_and = logic_and .and. logics(i)
        end do
!$omp end parallel do

        if (.not. logic_and) then
          result = result + 1
          write(1,*) "Error in logic AND part 1"
        end if


        logic_and = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel do schedule(dynamic,1) reduction(.and.:logic_and)
        do i=1,LOOPCOUNT
          logic_and = logic_and .and. logics(i)
        end do
!$omp end parallel do

        if (logic_and) then
           result = result + 1
           write(1,*) "Error in logic AND pass 2"
        end if

        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

!$omp parallel do schedule(dynamic,1) reduction(.or.:logic_or)
        do i = 1, LOOPCOUNT
           logic_or = logic_or .or. logics(i)
        end do
!$omp end parallel do

        if (logic_or) then
          result = result + 1
          write(1,*) "Error in logic OR part 1"
        end if

        logic_or = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel do schedule(dynamic,1) reduction(.or.:logic_or)
        do i=1,LOOPCOUNT
           logic_or = logic_or .or. logics(i)
        end do
!$omp end parallel do

        if ( .not. logic_or ) then
          result = result + 1
          write(1,*) "Error in logic OR part 2"
        end if

!... Test logic EQV, unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .true.
        end do

        logic_eqv = .true.

!$omp parallel do schedule(dynamic,1) reduction(.eqv.:logic_eqv)
        do i = 1, LOOPCOUNT
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end parallel do

        if (.not. logic_eqv) then
          result = result + 1
          write(1,*) "Error in logic EQV part 1"
        end if

        logic_eqv = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel do schedule(dynamic,1) reduction(.eqv.:logic_eqv)
        do i=1,LOOPCOUNT
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end parallel do

        if ( logic_eqv ) then
          result = result + 1
          write(1,*) "Error in logic EQV part 2"
        end if

!... Test logic NEQV, which is unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

        logic_neqv = .false.

!$omp parallel do schedule(dynamic,1) reduction(.neqv.:logic_neqv)
        do i = 1, LOOPCOUNT
           logic_neqv = logic_neqv .neqv. logics(i)
        end do
!$omp end parallel do

        if (logic_neqv) then
          result = result + 1
          write(1,*) "Error in logic NEQV part 1"
        end if

        logic_neqv = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel do schedule(dynamic,1) reduction(.neqv.:logic_neqv)
        do i=1,LOOPCOUNT
           logic_neqv = logic_neqv .neqv. logics(i)
        end do
!$omp end parallel do

        if ( .not. logic_neqv ) then
          result = result + 1
          write(1,*) "Error in logic NEQV part 2"
        end if

        do i=1, LOOPCOUNT
           int_array(i) = 1
        end do
!$omp parallel do schedule(dynamic,1) reduction(iand:bit_and)
        do i=1, LOOPCOUNT
!... iand(I,J): Returns value resulting from boolean AND of 
!... pair of bits in each of I and J. 
         bit_and = iand(bit_and,int_array(i))
        end do
!$omp end parallel do

        if ( bit_and .lt. 1 ) then
          result = result + 1
          write(1,*) "Error in IAND part 1"
        end if

        bit_and = 1
        int_array(LOOPCOUNT/2) = 0

!$omp parallel do schedule(dynamic,1) reduction(iand:bit_and)
        do i=1, LOOPCOUNT
          bit_and = Iand ( bit_and, int_array(i) )
        end do
!$omp end parallel do

        if( bit_and .ge. 1) then
           result = result + 1
          write(1,*) "Error in IAND part 2"
        end if

      do i=1, LOOPCOUNT
        int_array(i) = 0
      end do


!$omp parallel do schedule(dynamic,1) reduction(ior:bit_or)
        do i=1, LOOPCOUNT
!... Ior(I,J): Returns value resulting from boolean OR of 
!... pair of bits in each of I and J. 
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end parallel do

        if ( bit_or .ge. 1) then
           result = result + 1
          write(1,*) "Error in Ior part 1"
        end if


        bit_or = 0
        int_array(LOOPCOUNT/2) = 1
!$omp parallel do schedule(dynamic,1) reduction(ior:bit_or)
        do i=1, LOOPCOUNT
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end parallel do

        if ( bit_or .le. 0) then
           result = result + 1
          write(1,*) "Error in Ior part 2"
        end if

        do i=1, LOOPCOUNT
          int_array(i) = 0
        end do

!$omp parallel do schedule(dynamic,1) reduction(ieor:exclusiv_bit_or)
        do i = 1, LOOPCOUNT
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end parallel do

        if ( exclusiv_bit_or .ge. 1) then
           result = result + 1
           write(1,*) "Error in Ieor part 1"
        end if

        exclusiv_bit_or = 0
        int_array(LOOPCOUNT/2) = 1

!$omp parallel do schedule(dynamic,1) reduction(ieor:exclusiv_bit_or)
        do i = 1, LOOPCOUNT
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end parallel do

        if ( exclusiv_bit_or .le. 0) then
          result = result + 1
          write(1,*) "Error in Ieor part 2"
        end if

        do i=1,LOOPCOUNT
           int_array(i) = 10 - i
        end do

        min_value = 65535

!$omp parallel do schedule(dynamic,1) reduction(min:min_value)
        do i = 1, LOOPCOUNT
            min_value = min(min_value,int_array(i) )
        end do
!$omp end parallel do

        if ( min_value .gt. (10-LOOPCOUNT) )then
          result = result + 1
          write(1,*) "Error in integer MIN"
        end if


        do i=1,LOOPCOUNT
           int_array(i) = i
        end do

        max_value = -32768

!$omp parallel do schedule(dynamic,1) reduction(max:max_value)
        do i = 1, LOOPCOUNT
            max_value = max(max_value,int_array(i) )
        end do
!$omp end parallel do

        if ( max_value .lt. LOOPCOUNT )then
          result = result + 1
          write(1,*) "Error in integer MAX"
        end if

!... test double min, max
        do i=1,LOOPCOUNT
           d_array(i) = 10 - i*dt
        end do

        dmin = 2**10
        dt = 0.5

!$omp parallel do schedule(dynamic,1) reduction(min:dmin)
        do i = 1, LOOPCOUNT
            dmin= min(dmin,d_array(i) )
        end do
!$omp end parallel do

        if ( dmin .gt. (10-dt) )then
          result = result + 1
          write(1,*) "Error in double MIN"
        end if


        do i=1,LOOPCOUNT
           d_array(i) = i * dt
        end do

        dmax= - (2**10)

!$omp parallel do schedule(dynamic,1) reduction(max:dmax)
        do i = 1, LOOPCOUNT
            dmax= max(dmax,d_array(i) )
        end do
!$omp end parallel do

        if ( dmax .lt. LOOPCOUNT*dt )then
          result = result + 1
          write(1,*) "Error in double MAX"
        end if

        if ( result .eq. 0 ) then
           chk_par_do_reduction =  1
        else
           chk_par_do_reduction =  0
        end if

       end


!        integer function chk_par_do_reduction(logFile)
        integer function crschk_par_do_reduction()
        implicit none
        integer sum, sum2, known_sum, i, i2,diff
        integer product,known_product,int_const
        integer MAX_FACTOR
        double precision dsum,dknown_sum,dt,dpt
        double precision rounding_error, ddiff
        integer double_DIGITS
        logical logic_and, logic_or, logic_eqv,logic_neqv
        integer bit_and, bit_or
        integer exclusiv_bit_or
        integer min_value, max_value
        double precision dmin, dmax
        integer result
        include "omp_testsuite.f"
        logical logics(LOOPCOUNT)
        integer int_array(LOOPCOUNT)
        double precision d_array(LOOPCOUNT)
        parameter (int_const=10,known_product=3628800)
        parameter (DOUBLE_DIGITS=20,MAX_FACTOR=10)
        parameter (rounding_error=1.E-6)
        dt = 1./3.
        known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2
        product = 1
        sum2 = 0
        sum = 0
        dsum = 0.
        result =0 
        logic_and = .true.
        logic_or = .false.
        bit_and = 1
        bit_or = 0
        exclusiv_bit_or = 0
!$omp parallel do schedule(dynamic, 1) 
        do i =1, LOOPCOUNT
          sum = sum + i
        end do
!$omp end parallel do

       if (known_sum .ne. sum) then
             result = result + 1
       end if

        diff = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2



!$omp parallel do schedule(dynamic, 1) 
        do i =1, LOOPCOUNT
          diff = diff - i
        end do
!$omp end parallel do
  
        if ( diff .NE. 0 ) then
          result = result + 1
!        write(1,*) "Error in difference with integers: Result was ",
!     &   sum,"instead of 0."
        end if

!... Test for doubles
        dsum =0.
        dpt = 1

        do i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        end do
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel do schedule(dynamic,1) 
        do i=0,DOUBLE_DIGITS-1
              dsum = dsum + dt**i
        end do
!$omp end parallel do

 
        if(dsum .ne. dknown_sum .or. 
     &     abs(dsum - dknown_sum) .gt. rounding_error ) then
           result = result + 1
!           write(1,*) "Error in sum with doubles: Result was ",
!     &       dsum,"instead of ",dknown_sum,"(Difference: ",
!     &       dsum - dknown_sum,")"
        end if
        dpt = 1


      
        do i=1, DOUBLE_DIGITS
           dpt = dpt*dt
        end do
        ddiff = ( 1-dpt)/(1-dt)
!$omp parallel do schedule(dynamic,1) 
        do i=0, DOUBLE_DIGITS-1
          ddiff = ddiff - dt**i
        end do
!$omp end parallel do

        if ( ddiff .GT. rounding_error .or.
     &       ddiff .GT. (-rounding_error) ) then
           result = result + 1
!           write(1,*) "Error in Difference with doubles: Result was ",
!     &       ddiff,"instead of 0.0"
        end if

!$omp parallel do schedule(dynamic,1) 
        do i=1,MAX_FACTOR
           product = product * i
        end do
!$omp end parallel do

        if (known_product .NE. product) then
           result = result + 1
!           write(1,*) "Error in Product with integers: Result was ",
!     &       product," instead of",known_product 
        end if

        do i=1,LOOPCOUNT
          logics(i) = .true.
        end do

!$omp parallel do schedule(dynamic,1) 
        do i=1,LOOPCOUNT
          logic_and = logic_and .and. logics(i)
        end do
!$omp end parallel do

        if (.not. logic_and) then
          result = result + 1
!          write(1,*) "Error in logic AND part 1"
        end if


        logic_and = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel do schedule(dynamic,1) 
        do i=1,LOOPCOUNT
          logic_and = logic_and .and. logics(i)
        end do
!$omp end parallel do

        if (logic_and) then
           result = result + 1
!           write(1,*) "Error in logic AND pass 2"
        end if




        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
           logic_or = logic_or .or. logics(i)
        end do
!$omp end parallel do

        if (logic_or) then
          result = result + 1
!	  write(1,*) "Error in logic OR part 1"
        end if

        logic_or = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel do schedule(dynamic,1) 
        do i=1,LOOPCOUNT
           logic_or = logic_or .or. logics(i)
        end do
!$omp end parallel do

        if ( .not. logic_or ) then
          result = result + 1
!          write(1,*) "Error in logic OR part 2"
        end if

!... Test logic EQV, unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .true.
        end do

        logic_eqv = .true.

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end parallel do

        if (.not. logic_eqv) then
          result = result + 1
!	  write(1,*) "Error in logic EQV part 1"
        end if

        logic_eqv = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel do schedule(dynamic,1) 
        do i=1,LOOPCOUNT
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end parallel do

        if ( logic_eqv ) then
          result = result + 1
!          write(1,*) "Error in logic EQV part 2"
        end if

!... Test logic NEQV, which is unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

        logic_neqv = .false.

!$omp parallel do schedule(dynamic,1)
        do i = 1, LOOPCOUNT
           logic_neqv = logic_neqv .neqv. logics(i)
        end do
!$omp end parallel do

        if (logic_neqv) then
          result = result + 1
!	  write(1,*) "Error in logic NEQV part 1"
        end if

        logic_neqv = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel do schedule(dynamic,1)
        do i=1,LOOPCOUNT
           logic_neqv = logic_neqv .neqv. logics(i)
        end do
!$omp end parallel do

        if ( .not. logic_neqv ) then
          result = result + 1
!          write(1,*) "Error in logic NEQV part 2"
        end if


        do i=1, LOOPCOUNT
           int_array(i) = 1
        end do
!$omp parallel do schedule(dynamic,1) 
        do i=1, LOOPCOUNT
!... iand(I,J): Returns value resulting from boolean AND of 
!... pair of bits in each of I and J. 
         bit_and = iand(bit_and,int_array(i))
        end do
!$omp end parallel do

        if ( bit_and .lt. 1 ) then
          result = result + 1
!          write(1,*) "Error in IAND part 1"
        end if

        bit_and = 1
        int_array(LOOPCOUNT/2) = 0

!$omp parallel do schedule(dynamic,1) 
        do i=1, LOOPCOUNT
          bit_and = Iand ( bit_and, int_array(i) )
        end do
!$omp end parallel do

        if( bit_and .ge. 1) then
           result = result + 1
!          write(1,*) "Error in IAND part 2"
        end if

      do i=1, LOOPCOUNT
        int_array(i) = 0
      end do


!$omp parallel do schedule(dynamic,1) 
        do i=1, LOOPCOUNT
!... Ior(I,J): Returns value resulting from boolean OR of 
!... pair of bits in each of I and J. 
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end parallel do

        if ( bit_or .ge. 1) then
           result = result + 1
!          write(1,*) "Error in Ior part 1"
        end if


        bit_or = 0
        int_array(LOOPCOUNT/2) = 1
!$omp parallel do schedule(dynamic,1) 
        do i=1, LOOPCOUNT
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end parallel do

        if ( bit_or .le. 0) then
           result = result + 1
!          write(1,*) "Error in Ior part 2"
        end if

        do i=1, LOOPCOUNT
          int_array(i) = 0
        end do

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end parallel do

        if ( exclusiv_bit_or .ge. 1) then
           result = result + 1
!           write(1,*) "Error in Ieor part 1"
        end if

        exclusiv_bit_or = 0
        int_array(LOOPCOUNT/2) = 1

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end parallel do

        if ( exclusiv_bit_or .le. 0) then
          result = result + 1
!          write(1,*) "Error in Ieor part 2"
        end if

        do i=1,LOOPCOUNT
           int_array(i) = 10 - i
        end do

        min_value = 65535

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
            min_value = min(min_value,int_array(i) )
        end do
!$omp end parallel do


        if ( min_value .gt. (10-LOOPCOUNT) )then
          result = result + 1
!          write(1,*) "Error in integer MIN"
        end if

        do i=1,LOOPCOUNT
           int_array(i) = i
        end do

        max_value = -32768

!$omp parallel do schedule(dynamic,1)
        do i = 1, LOOPCOUNT
            max_value = max(max_value,int_array(i) )
        end do
!$omp end parallel do

        if ( max_value .lt. LOOPCOUNT )then
          result = result + 1
!          write(1,*) "Error in integer MAX"
        end if

!... test double min, max
        do i=1,LOOPCOUNT
           d_array(i) = 10 - i*dt
        end do

        dmin = 2**10
        dt = 0.5

!$omp parallel do schedule(dynamic,1) reduction(min:dmin)
        do i = 1, LOOPCOUNT
            dmin= min(dmin,d_array(i) )
        end do
!$omp end parallel do

        if ( dmin .gt. (10-dt) )then
          result = result + 1
!          write(1,*) "Error in double MIN"
        end if


        do i=1,LOOPCOUNT
           d_array(i) = i * dt
        end do

        dmax= - (2**10)

!$omp parallel do schedule(dynamic,1) 
        do i = 1, LOOPCOUNT
            dmax= max(dmax,d_array(i) )
        end do
!$omp end parallel do

        if ( dmax .lt. LOOPCOUNT*dt )then
          result = result + 1
!          write(1,*) "Error in double MAX"
        end if

        if ( result .eq. 0 ) then
           crschk_par_do_reduction =  1
        else
           crschk_par_do_reduction =  0
        end if

        close(2)

       end

