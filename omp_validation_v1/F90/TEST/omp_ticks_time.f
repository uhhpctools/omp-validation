!********************************************************************
! Functions: chk_omp_ticks_time
!********************************************************************


      integer function chk_omp_ticks_time(fileunit)
      implicit none
      double precision tick
      double precision omp_get_wtick
      integer fileunit
      tick=omp_get_wtick()
      write(1,*) "work took",tick,"sec. time."
      if(tick .gt. 0. .AND. tick .lt. 0.01) then
              chk_omp_ticks_time=1
      else
              chk_omp_ticks_time=0
      endif
      end

      integer function crschk_omp_ticks_time()
      implicit none
      double precision tick
      tick=0.0
!      tick=omp_get_wtick()
      if(tick .gt. 0 .AND. tick .lt. 0.01) then
              crschk_omp_ticks_time=1
      else
              crschk_omp_ticks_time=0
      endif
      end


