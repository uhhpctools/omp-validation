<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for firstprivate directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel for firstprivate</ompts:directive>
<ompts:dependences>omp parallel for reduction,omp parallel for private</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_parallel_for_firstprivate</ompts:testcode:functionname>(FILE * logFile)
{
    int sum = 0;
    int known_sum;
    int i2 = 3;
    int i;

#pragma omp parallel for reduction(+:sum) <ompts:check>firstprivate(i2)</ompts:check><ompts:crosscheck>private(i2)</ompts:crosscheck>
    for (i = 1; i <= LOOPCOUNT; i++)
    {
	sum = sum + (i + i2);
    } /*end of for*/

    known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2 + i2 * LOOPCOUNT;
    return (known_sum == sum);
} /* end of check_parallel_for_fistprivate */
</ompts:testcode>
</ompts:test>
