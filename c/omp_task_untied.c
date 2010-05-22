<ompts:test>
<ompts:testdescription>Test which checks the untied clause of the omp task directive. The idear of the tests is to generate a set of tasks in a single region. We create more tasks then threads exist, so at least one thread should handle more than one thread. Then we send the half of the threads into a bussy loop. We let finish the other threads. Now we should get rescheduled some untied tasks to the idle threads.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp task untied</ompts:directive>
<ompts:dependences>omp single, omp flush</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int <ompts:testcode:functionname>omp_task_untied</ompts:testcode:functionname>(FILE * logFile){
    int i;
    <ompts:orphan:vars>
    int result = 0;
    int started = 0;
    int state = 1;
    int num_tasks = 0;
    int num_threads;
    int max_num_tasks;
    </ompts:orphan:vars>


    #pragma omp parallel 
    {
        #pragma omp single
        {
            num_threads = omp_get_num_threads();
            max_num_tasks = num_threads * MAX_TASKS_PER_THREAD;

            for (i = 0; i < max_num_tasks; i++) {
                <ompts:orphan>
                #pragma omp task <ompts:check>untied</ompts:check>
                {
                    int start_tid;
                    int current_tid;

                    start_tid = omp_get_thread_num();
                    #pragma omp critical
                    { num_tasks++; }

                    while (num_tasks < max_num_tasks) {
                        my_sleep (SLEEPTIME);
                        #pragma omp flush (num_tasks)
                    }


                    if ((start_tid % 2) == 0) {
                        do {
                            my_sleep (SLEEPTIME);
                            current_tid = omp_get_thread_num ();
                            if (current_tid != start_tid) {
                                #pragma omp critical
                                { result++; }
                                break;
                            }
                            #pragma omp flush (state)
                        } while (state);
                    } 
                } /* end of omp task */
                </ompts:orphan>
            } /* end of for */

            /* wait until all tasks have been created and were sheduled at least
             * a first time */
            while (num_tasks < max_num_tasks) {
                my_sleep (SLEEPTIME);
                #pragma omp flush (num_tasks)
            }
            /* wait a little moment more until we stop the test */
            my_sleep(SLEEPTIME_LONG);
            state = 0;
        } /* end of single */
    } /* end of parallel */

    return result;
} 
</ompts:testcode>
</ompts:test>
