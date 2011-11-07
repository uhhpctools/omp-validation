<ompts:test>
<ompts:testdescription>Test with omp for collapse clause. Bind with two loops. Without the collapse clause, the first loop will not be ordered</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp for collapse</ompts:directive>
<ompts:dependences>omp critical,omp for schedule</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <math.h>

#include "omp_testsuite.h"

static int last_i = 0;

/* Utility function to check that i is increasing monotonically 
   with each call */
static int check_i_islarger (int i)
{
    int islarger;
    islarger = (i >= last_i);
    last_i = i;
    return (islarger);
}

int <ompts:testcode:functionname>omp_for_collapse</ompts:testcode:functionname> (FILE * logFile)
{
    <ompts:orphan:vars>
	int sum;
	int is_larger = 1;
    </ompts:orphan:vars>
    int known_sum;

    last_i = 0;
    sum = 0;

#pragma omp parallel
    {
	<ompts:orphan>
	    int i,j;
	    int my_islarger = 1;
#pragma omp for schedule(static,1) <ompts:check>collapse(2)</ompts:check> ordered
	    for (i = 1; i < 100; i++)
          for (j =1; j <100; j++)
          {
		    #pragma omp ordered
		    {
		      my_islarger = check_i_islarger(i) && my_islarger;
		      sum = sum + i;
		    }	/* end of ordered */
	      }	/* end of for */
#pragma omp critical
	    {
		is_larger = is_larger && my_islarger;
	    }	/* end of critical */
	</ompts:orphan>
    }

    known_sum=(99 * 100) / 2 * 99;
    return ((known_sum == sum) && is_larger);
}
</ompts:testcode>
</ompts:test>
