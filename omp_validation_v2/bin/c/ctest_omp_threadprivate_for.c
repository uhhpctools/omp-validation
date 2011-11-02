
#include "omp_testsuite.h"
#include <stdlib.h>
#include <stdio.h>

static int i;


int ctest_omp_threadprivate_for(FILE * logFile)
{
		int known_sum;
		int sum;
		known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2;
		sum = 0;

#pragma omp parallel
	{
		int sum0 = 0;
#pragma omp for
		for (i = 1; i <= LOOPCOUNT; i++)
		{
			sum0 = sum0 + i;
		} /*end of for*/
#pragma omp critical
		{
			sum = sum + sum0;
		} /*end of critical */
	} /* end of parallel */    
	
	if (known_sum != sum ) {
		fprintf (logFile, " known_sum = %d, sum = %d\n", known_sum, sum);
	}

	return (known_sum == sum);

} /* end of check_threadprivate*/
int main()
{
	int i;			/* Loop index */
	int result;		/* return value of the program */
	int failed=0; 		/* Number of failed tests */
	int success=0;		/* number of succeeded tests */
	static FILE * logFile;	/* pointer onto the logfile */
	static const char * logFileName = "bin/c/ctest_omp_threadprivate_for.log";	/* name of the logfile */


	/* Open a new Logfile or overwrite the existing one. */
	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	printf("## Repetitions: %3d                       ####\n",REPETITIONS);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing omp threadprivate\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	fprintf(logFile,"## Repetitions: %3d                       ####\n",REPETITIONS);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing omp threadprivate\n\n");

	for ( i = 0; i < REPETITIONS; i++ ) {
		fprintf (logFile, "\n\n%d. run of ctest_omp_threadprivate_for out of %d\n\n",i+1,REPETITIONS);
		if(ctest_omp_threadprivate_for(logFile)){
			fprintf(logFile,"Test successful.\n");
			success++;
		}
		else {
			fprintf(logFile,"Error: Test failed.\n");
			printf("Error: Test failed.\n");
			failed++;
		}
	}

    if(failed==0){
		fprintf(logFile,"\nDirective worked without errors.\n");
		printf("Directive worked without errors.\n");
		result=0;
	}
	else{
		fprintf(logFile,"\nDirective failed the test %i times out of %i. %i were successful\n",failed,REPETITIONS,success);
		printf("Directive failed the test %i times out of %i.\n%i test(s) were successful\n",failed,REPETITIONS,success);
		result = (int) (((double) failed / (double) REPETITIONS ) * 100 );
	}
	printf ("Result: %i\n", result);
	return result;
}
