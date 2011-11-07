#include "omp_testsuite.h"


	int sum, num_threads,sum1;
    

/* Declaration of the functions containing the code for the orphan regions */
#include <stdio.h>


/* End of declaration */


#include <stdio.h>
#include <stdlib.h>
#include "omp_testsuite.h"

//static int sum1 = 789;

int orph_test_omp_parallel_private(FILE * logFile)
{
    
    int known_sum;

    sum = 0;
    
    num_threads = 0;


#pragma omp parallel private(sum1)
    {
	
	sum1 = 7;
	
	/*printf("sum1=%d\n",sum1);*/
	
	int i;
#pragma omp for 
	    for (i = 1; i < 1000; i++)
	    {
		sum1 = sum1 + i;
	    } /*end of for*/
#pragma omp critical
	{
	    sum = sum + sum1;
            num_threads++;
	} /*end of critical*/
	
    } /* end of parallel*/    
    known_sum = (999 * 1000) / 2 + 7 * num_threads;
    return (known_sum == sum);

}
int main()
{
	int i;			/* Loop index */
	int result;		/* return value of the program */
	int failed=0; 		/* Number of failed tests */
	int success=0;		/* number of succeeded tests */
	static FILE * logFile;	/* pointer onto the logfile */
	static const char * logFileName = "bin/c/orph_test_omp_parallel_private.log";	/* name of the logfile */


	/* Open a new Logfile or overwrite the existing one. */
	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	printf("## Repetitions: %3d                       ####\n",REPETITIONS);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing omp parallel private\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	fprintf(logFile,"## Repetitions: %3d                       ####\n",REPETITIONS);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing omp parallel private\n\n");

	for ( i = 0; i < REPETITIONS; i++ ) {
		fprintf (logFile, "\n\n%d. run of orph_test_omp_parallel_private out of %d\n\n",i+1,REPETITIONS);
		if(orph_test_omp_parallel_private(logFile)){
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

/* Automatically generated definitions of the orphan functions */

void orph1_omp_parallel_private (FILE * logFile) {
	int i;
#pragma omp for 
	    for (i = 1; i < 1000; i++)
	    {
		sum1 = sum1 + i;
	    } /*end of for*/
#pragma omp critical
	{
	    sum = sum + sum1;
            num_threads++;
	} /*end of critical*/
	
}
/* End of automatically generated definitions */
