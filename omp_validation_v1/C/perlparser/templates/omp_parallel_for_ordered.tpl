<ompts:test>
<ompts:testdescription>Test which checks the omp parallel for ordered directive</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel for ordered</ompts:directive>
<ompts:dependences>omp parallel schedule(static)</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

static int last_i = 0;

/*! 
  Utility function: returns true if the passed argument is larger than 
  the argument of the last call of this function.
  */
static int check_i_islarger2 (int i){
	int islarger;
	islarger = (i > last_i);
	last_i = i;
	return (islarger);
}

int <ompts:testcode:functionname>omp_parallel_for_ordered</ompts:testcode:functionname>(FILE * logFile){
	<ompts:orphan:vars>
	int sum;
	int is_larger;
	int i;
	</ompts:orphan:vars>

	int known_sum;

	sum = 0;
	is_larger = 1;
	last_i = 0;
#pragma omp parallel for schedule(static,1) <ompts:check>ordered</ompts:check>
	for (i = 1; i < 100; i++)
	{
	<ompts:orphan>
<ompts:check>#pragma omp ordered</ompts:check><ompts:crosscheck></ompts:crosscheck>
		{
			is_larger = check_i_islarger2 (i) && is_larger;
			sum  = sum + i;
		}
	</ompts:orphan>
	}
	known_sum = (99 * 100) / 2;
	fprintf (logFile," known_sum = %d , sum = %d \n", known_sum, sum);
	fprintf (logFile," is_larger = %d\n", is_larger);
	return (known_sum == sum) && is_larger;
}
</ompts:testcode>
</ompts:test>
