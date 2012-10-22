<ompts:test>
<ompts:testdescription>Test which checks the omp task directive. The idea of the tests is to generate a set of tasks in a single region. We let pause the tasks generated so that other threads get sheduled to the newly opened tasks.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp task</ompts:directive>
<ompts:dependences>omp single</ompts:dependences>
<ompts:testcode>
      INCLUDE "omp_my_sleep.f"

      INTEGER FUNCTION <ompts:testcode:functionname>omp_task</ompts:testcode:functionname>()
        IMPLICIT NONE
        INCLUDE "omp_testsuite.f"
        <ompts:orphan:vars>
        EXTERNAL my_sleep
        INTEGER myi
        INTEGER i
        INTEGER tids(NUM_TASKS)
        COMMON /orphvars/ i, tids
        </ompts:orphan:vars>
!$omp parallel private(myi) shared(i)
!$omp single
        do i=1, NUM_TASKS
        <ompts:orphan>
        myi = i
        <ompts:check>
!$omp task
        </ompts:check>
          call my_sleep(SLEEPTIME)
          tids(myi) = omp_get_thread_num()
        <ompts:check>
!$omp end task
        </ompts:check>
        </ompts:orphan>
        end do
!$omp end single
!$omp end parallel

        <testfunctionname></testfunctionname> = 0

        ! check if more than one thread executed the tasks.
        do i=1, NUM_TASKS
          if (tids(1) .ne. tids(i)) then
               <testfunctionname></testfunctionname> = 1
          end if
        end do

      END FUNCTION
</ompts:testcode>
</ompts:test>
