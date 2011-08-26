<ompts:test>
<ompts:testdescription>Test which checks the omp parallel sections private directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel sections private</ompts:directive>
<ompts:dependences>omp critical</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include "omp_testsuite.h"

int <ompts:testcode:functionname>omp_parallel_sections_private</ompts:testcode:functionname>(FILE * logFile){
  int sum=7;
  int sum0=0;
  int known_sum;
  int i;
#pragma omp parallel sections private(<ompts:check>sum0,</ompts:check><ompts:crosscheck></ompts:crosscheck>i)
  {
#pragma omp section 
    {
      sum0=0;
      for (i=1;i<400;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }    
#pragma omp section
    {
      sum0=0;
      for(i=400;i<700;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }
#pragma omp section
    {
      sum0=0;
      for(i=700;i<1000;i++)
	sum0=sum0+i;
#pragma omp critical
      {
	sum= sum+sum0;
      }                         /*end of critical */
    }               
  }        /*end of paralell sections*/
known_sum=(999*1000)/2+7;
return (known_sum==sum); 
}                              /* end of check_section_private*/
</ompts:testcode>
</ompts:test>
