<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for lastprivate directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel for lastprivate</ompts:directive>
<ompts:dependences>omp parallel for reduction,omp parallel for private</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_parallel_for_lastprivate</ompts:testcode:functionname>(FILE * logFile){
    int sum = 0;
    /*int sum0 = 0;*/
    int known_sum;
    int i;
    int i0 = -1;

#pragma omp parallel for reduction(+:sum) schedule(static,7) <ompts:check>lastprivate(i0)</ompts:check><ompts:crosscheck>private(i0)</ompts:crosscheck>
    for (i = 1; i <= LOOPCOUNT; i++)
    {
	sum = sum + i;
	i0 = i;
    } /*end of for*/
    /* end of parallel*/    
    known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2;
    return ((known_sum == sum) && (i0 == LOOPCOUNT));
} /* end of check_parallel_for_lastprivate */
</ompts:testcode>
</ompts:test>
