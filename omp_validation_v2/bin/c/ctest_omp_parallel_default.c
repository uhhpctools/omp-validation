
#include <stdio.h>
#include <unistd.h>

#include "omp_testsuite.h"

int ctest_omp_parallel_default (FILE * logFile)
{
  int i;
  int sum = 0;
  int known_sum;
  int mysum;

  known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2 ;

#pragma omp parallel  private(mysum,sum)
  {
	mysum = 0;
#pragma omp for
	for (i = 1; i <= LOOPCOUNT; i++)
	{
	  mysum = mysum + i;
	} 
#pragma omp critical
	{
	  sum = sum + mysum;
	}   /* end of critical */
  }   /* end of parallel */
  if (known_sum != sum) {
  	fprintf(logFile, "KNOWN_SUM = %d; SUM = %d\n", known_sum, sum);
  }
  return (known_sum == sum);
}
int main()
{
	int i;			/* Loop index */
	int result;		/* return value of the program */
	int failed=0; 		/* Number of failed tests */
	int success=0;		/* number of succeeded tests */
	static FILE * logFile;	/* pointer onto the logfile */
	static const char * logFileName = "bin/c/ctest_omp_parallel_default.log";	/* name of the logfile */


	/* Open a new Logfile or overwrite the existing one. */
	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	printf("## Repetitions: %3d                       ####\n",REPETITIONS);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing omp parallel default\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	fprintf(logFile,"## Repetitions: %3d                       ####\n",REPETITIONS);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing omp parallel default\n\n");

	for ( i = 0; i < REPETITIONS; i++ ) {
		fprintf (logFile, "\n\n%d. run of ctest_omp_parallel_default out of %d\n\n",i+1,REPETITIONS);
		if(ctest_omp_parallel_default(logFile)){
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
