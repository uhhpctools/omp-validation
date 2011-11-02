<ompts:test>
<ompts:testdescription>Test which checks the if option of the parallel construct.</ompts:testdescription>
<ompts:ompversion>3.0</ompts:ompversion>
<ompts:directive>omp parallel if</ompts:directive>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>

#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_parallel_if</ompts:testcode:functionname> (FILE * logFile)
{
  int i;
  int sum = 0;
  int known_sum;
  int mysum;
  int control=1;

  known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2 ;

#pragma omp parallel <ompts:check>if(control==0)</ompts:check>
  {
	mysum = 0;
	for (i = 1; i <= LOOPCOUNT; i++)
	{
	  mysum = mysum + i;
	} 
#pragma omp critical
	{
	  sum = sum + mysum;
	}   /* end of critical */
  }   /* end of parallel */
  

  return (known_sum == sum);
}
</ompts:testcode>
</ompts:test>
