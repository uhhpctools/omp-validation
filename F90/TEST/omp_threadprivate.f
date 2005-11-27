!********************************************************************
! Functions: chk_omp_threadprivate
!********************************************************************
!Yi Wen modified this function from his own understanding of the semantics
!of C version at 05042004
!The undeestanding is that sum0 and myvalue can be local static variables
!of the chk_omp_threadprivate function. There is no need to use common
!block
        integer function chk_omp_threadprivate()
        implicit none
	integer sum, known_sum, i , iter, rank,size, failed
!Yi Wen modified at 05042004 : add "save"
	integer,save:: sum0
        real, save::myvalue
	integer omp_get_num_threads, omp_get_thread_num
        real my_random
	real, allocatable:: data(:)
        integer random_size
	intrinsic random_number
        intrinsic random_seed
        external omp_set_dynamic
!Yi Wen commented two common blocks
!	common/csum0/ sum0
!	common/cmyvalue/ myvalue
!!!!!!!!!!$omp threadprivate(/csum0/,/cmyvalue/)
!$omp threadprivate(sum0,myvalue)
	include "omp_testsuite.f"
	sum = 0
	failed = 0
        sum0=0
        myvalue=0
        random_size=45
        call omp_set_dynamic(.FALSE.)
!$omp parallel
	sum0 = 0
!$omp do
	do i=1, LOOPCOUNT
	  sum0 = sum0 + i
	end do
!$omp end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .ne. sum ) then
	  print *, ' known_sum =', known_sum, ', sum =',sum
	end if

	call omp_set_dynamic(.FALSE.)
	
!$omp parallel
!$omp master
	size = omp_get_num_threads()
	allocate ( data(size) )
!$omp end master
!$omp end parallel
        call random_seed(SIZE=random_size)
	do iter = 0, 99
	  call random_number(harvest=my_random)
!$omp parallel private(rank)
	  rank = omp_get_thread_num()+1
	  myvalue = my_random + rank
	  data(rank) = myvalue
!$omp end parallel
!$omp parallel private(rank)
	  rank = omp_get_thread_num()+1
	  if ( myvalue .ne. data(rank) ) then
	   failed = failed + 1
	   print *, ' myvalue =',myvalue,' data(rank)=', data(rank)
	  end if
!$omp end parallel
	end do
	deallocate( data)
	if ( known_sum .eq. sum .and. failed .ne. 1) then
	  chk_omp_threadprivate = 1
	else
	  chk_omp_threadprivate = 0 
	end if
	end

	integer function crschk_omp_threadprivate()
        implicit none
	integer sum, known_sum, i, iter, rank, size, failed
	integer sum1
        real my_random
        integer, save::crosssum0
        real, save::crossmyvalue
        integer omp_get_num_threads,omp_get_thread_num
        integer random_size
	intrinsic random_number
        intrinsic random_seed
        external omp_set_dynamic
	real, allocatable :: data(:)
!	common sum0, myvalue, crossmyvalue
!Yi Wen commented comm block below at 05042004
!	common/csum1/sum1
!!!!!!!!!$omp threadprivate(/csum1/)
        include "omp_testsuite.f"
	sum1 = 789
        sum = 0
	failed = 0
        random_size=45
	call omp_set_dynamic(.FALSE.)
!$omp parallel
	crosssum0 = 0
!$omp do 
	do i=1, LOOPCOUNT
	   crosssum0 = crosssum0 + i
	end do
!$omp end do
!$omp critical
	sum = sum + crosssum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
!$omp parallel
!$omp master
	size = omp_get_num_threads()
	allocate ( data(size) )
!$omp end master
!$omp end parallel
        call random_seed(SIZE=random_size)
	do iter = 0, 99
	   call random_number(harvest=my_random)
!$omp parallel private(rank)
	   rank = omp_get_thread_num()+1
	   crossmyvalue = my_random + rank
	   data(rank) = crossmyvalue
!$omp end parallel
!$omp parallel reduction(+:failed) private(rank)
	   rank = omp_get_thread_num()+1
	   if ( crossmyvalue .ne. data(rank) ) then
	     failed = failed + 1
 	   end if
!$omp end parallel
	end do
	deallocate(data)
	if ( known_sum .eq. sum .and. failed .ne. 1) then
	  crschk_omp_threadprivate = 1
	else
	  crschk_omp_threadprivate = 0
	end if
	end

