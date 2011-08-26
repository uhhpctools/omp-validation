<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for private directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel for private</ompts:directive>
<ompts:dependences>omp parallel for reduction,omp flush</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>
#include "omp_testsuite.h"

/*! Utility function to spend some time in a loop */
static void do_some_work (void){
    int i;
    double sum = 0;
    for(i = 0; i < 1000; i++){
	sum += sqrt (i);
    }
}

int <ompts:testcode:functionname>omp_parallel_for_private</ompts:testcode:functionname>(FILE * logFile){
    int sum = 0;
    int known_sum;
    int i, i2;
#pragma omp parallel for reduction(+:sum) schedule(static,1) <ompts:check>private(i2)</ompts:check>
    for (i=1;i<=LOOPCOUNT;i++)
    {
	i2 = i;
#pragma omp flush
	do_some_work ();
#pragma omp flush
	sum = sum + i2;
    } /*end of for*/

    known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2;
    return (known_sum == sum);
} /* end of check_paralel_for_private */
</ompts:testcode>
</ompts:test>
