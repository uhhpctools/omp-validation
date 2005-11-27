!********************************************************************
! Functions: chk_omp_time
!********************************************************************

      integer function chk_omp_time(fileunit)
      implicit none
      double precision start
      double precision endtime
      double precision omp_get_wtime
      integer wait_time
      double precision measured_time
      integer fileunit
      wait_time=1
      start=omp_get_wtime()
      call sleep(wait_time)
      endtime=omp_get_wtime()
      measured_time=endtime-start
!      print *, "measureed time", measured_time
      write(1,*) "work took",measured_time,"sec. time."
      if(measured_time.gt.0.9*wait_time .AND.
     x measured_time .lt. 1.1*wait_time) then
              chk_omp_time=1
      else
              chk_omp_time=0
      endif
      end
!*****************************************************
      integer function crschk_omp_time(fileunit)
      implicit none
      double precision start
      double precision endtime
!      double precision omp_get_wtime
      integer wait_time
      double precision measured_time
      integer fileunit
      wait_time=1
      start=0
      endtime=0
      call sleep(wait_time)

      measured_time=endtime-start
      write(1,*) "work took",measured_time,"sec. time."

      if(measured_time.gt.0.9*wait_time .AND.
     x measured_time .lt. 1.1*wait_time) then
              crschk_omp_time=1
      else
              crschk_omp_time=0
      endif
      end

