<ompts:test>
<ompts:testdescription>Test which checks the guided option of the omp for schedule directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp for schedule(guided)</ompts:directive>
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

int <ompts:testcode:functionname>omp_for_schedule_guided</ompts:testcode:functionname> (FILE * logFile)
{
    int threads;

    <ompts:orphan:vars>
	int * tids;
	int * chunksizes;
	int notout;
	int maxiter;
    </ompts:orphan:vars>

    int i; 
    int m; 
    int tmp;
    int result;	

    tids = (int *) malloc (sizeof (int) * CFSMAX_SIZE);
    result = 1;	
    notout = 1;

#pragma omp parallel
    {
#pragma omp single
	{
	    threads = omp_get_num_threads ();
	}
    }

    if (threads < 2) {
	printf ("This test only works with at least two threads .\n");
	return (0);
    }

    /* Now the real parallel work:  

       Each thread will start immediately with the first chunk.

     */

#pragma omp parallel shared(tids) 
    {
	<ompts:orphan>
	    int tid;
	    int j;

	    tid = omp_get_thread_num ();

#pragma omp for nowait <ompts:check>schedule(guided,1)</ompts:check>
	    for(j = 0; j < CFSMAX_SIZE; j++)
	    {
		int count = 0;
		/* printf (" notout = %d, count = %d\n", notout, count); */
#pragma omp flush(maxiter)
		if (j > maxiter){
#pragma omp critical
		    {
			maxiter = j;
		    }
		}

		/* if it is not our turn we wait 
		   a) until another thread executed an iteration with a higher iteration count
		   b) we are at the end of the loop (first thread finished and set notout = 0 OR
		   c) timeout arrived */ 

		while (notout && (count < MAX_TIME) && (maxiter == j))
		{
		    /* printf ("Thread Nr. %d sleeping\n", tid); */
#pragma omp flush(maxiter,notout)
		    my_sleep (SLEEPTIME);
		    count += SLEEPTIME;
		}
		/* printf ("Thread Nr. %d working once\n", tid); */
		tids[j] = tid;
	    }	/* end omp for */
	</ompts:orphan>	

	notout = 0;
#pragma omp flush(notout)
    }	/* end omp parallel */

    m = 1;
    tmp = tids[0];

    {
	int global_chunknr = 0;
	int local_chunknr[NUMBER_OF_THREADS];
	int openwork = CFSMAX_SIZE;
	int expected_chunk_size;

	for(i = 0; i < NUMBER_OF_THREADS; i++)
	    local_chunknr[i] = 0;

	tids[CFSMAX_SIZE] = -1;


	/*fprintf(logFile,"# global_chunknr thread local_chunknr chunksize\n"); */
	for(i = 1; i <= CFSMAX_SIZE; ++i)
	{
	    if (tmp==tids[i]) {
		m++;
	    }
	    else
	    {
		fprintf (logFile, "%d\t%d\t%d\t%d\n", global_chunknr,tmp, local_chunknr[tmp], m);
		global_chunknr++;
		local_chunknr[tmp]++;
		tmp = tids[i];
		m = 1;
	    }
	}
	chunksizes = (int*)malloc(global_chunknr * sizeof(int));
	global_chunknr = 0;

	m = 1;
	tmp = tids[0];	    
	for (i = 1; i <= CFSMAX_SIZE; ++i)
	{
	    if (tmp == tids[i])
	    {
		m++;
	    }
	    else
	    {
		chunksizes[global_chunknr] = m;
		global_chunknr++;
		local_chunknr[tmp]++;
		tmp = tids[i];
		m = 1;
	    }
	}

	for (i = 0; i < global_chunknr; i++)
	{
	    if (expected_chunk_size>2) expected_chunk_size = openwork / threads;
	    result = result && (abs (chunksizes[i] - expected_chunk_size) < 2);
	    openwork -= chunksizes[i];
	}	
    }

    return result;
}
</ompts:testcode>
</ompts:test>

