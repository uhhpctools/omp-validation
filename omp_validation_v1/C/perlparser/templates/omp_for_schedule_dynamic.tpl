<ompts:test>
<ompts:testdescription>Test which checks the dynamic option of the omp for schedule directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp for schedule(dynamic)</ompts:directive>
<ompts:dependences>omp flush,omp for nowait,omp critical,omp single</ompts:dependences>
<ompts:testcode>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

#define NUMBER_OF_THREADS 10
#define CFSMAX_SIZE 1000
#define CFDMAX_SIZE 1000000
#define MAX_TIME 5
#define SLEEPTIME 0.5

const int chunk_size = 10;

int <ompts:testcode:functionname>omp_for_schedule_dynamic</ompts:testcode:functionname> (FILE * logFile)
{
<ompts:orphan:vars>
    int tid;
    int *tids;
</ompts:orphan:vars>

    int i;
    int tidsArray[CFDMAX_SIZE];
    int count = 0;
    int tmp_count = 0;
    int *tmp;
    int result = 1;

    tids = tidsArray;

#pragma omp parallel private(tid) shared(tids,count)
    { /* begin of parallel*/

	tid = omp_get_thread_num ();
	{	/* begin of orphaned block */
	<ompts:orphan>
	    int j;
#pragma omp for <ompts:check>schedule(dynamic,chunk_size)</ompts:check>
	    for (j = 0; j < CFDMAX_SIZE; ++j)
	    {
		tids[j] = tid;
	    }	/* end of for */
	</ompts:orphan>
	}	/* end of orphaned block */
    }	/* end of parallel */

    for (i = 0; i < CFDMAX_SIZE - 1; ++i){
	if(tids[i] != tids[i + 1])
	{
	    count++;
	}
    }

    tmp = (int*) malloc(sizeof (int) * (count + 1));
    tmp[0] = 1;

    for (i = 0; i < CFDMAX_SIZE - 1; ++i)
    {
	if (tmp_count > count) {
	    printf("--------------------\nTestinternal Error: List too small!!!\n--------------------\n"); /* Error handling */
	    break;
	}
	if (tids[i] != tids[i + 1]) {
	    tmp_count++;
	    tmp[tmp_count] = 1;
	}
	else {
	    tmp[tmp_count]++;
	}
    }

    /* is dynamic statement working? */

    for(i = 0; i < count + 1; ++i)
    {
	if(tmp[i] != chunk_size)
	{
	    result += ((tmp[i] / chunk_size) - 1);
	}
    }
    /* for (i = 0; i < count + 1; ++i) printf("%d\t:=\t%d\n", i + 1, tmp[i]); */
    if((tmp[0] != CFDMAX_SIZE) && (result > 1))
    {
	fprintf (logFile, "Seems to work. (Treads got %d times chunks \"twice\" by a total of %d chunks)\n", result, CFDMAX_SIZE / chunk_size); 
	return (1);
    }
    else
    {
	fprintf (logFile, "Test negativ.\n");
	return (0);
    }
}
</ompts:testcode>
</ompts:test>
