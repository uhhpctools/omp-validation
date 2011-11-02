#include "omp_testsuite.h"


	int serial;
	int isparallel;
    

/* Declaration of the functions containing the code for the orphan regions */
#include <stdio.h>


/* End of declaration */


/*
 * Checks that false is returned when called from serial region
 * and true is returned when called within parallel region. 
 */
#include <stdio.h>
#include "omp_testsuite.h"

int orph_test_omp_in_parallel(FILE * logFile){
    

    serial = 1;
    isparallel = 0;

    
	
	    serial = omp_in_parallel ();
	

#pragma omp parallel
    {
#pragma omp single
	{
	    
		isparallel = omp_in_parallel ();
	    
	}
    }
    

    

	return (!(serial) && isparallel);
}
int main()
{
	int i;			/* Loop index */
	int result;		/* return value of the program */
	int failed=0; 		/* Number of failed tests */
	int success=0;		/* number of succeeded tests */
	static FILE * logFile;	/* pointer onto the logfile */
	static const char * logFileName = "bin/c/orph_test_omp_in_parallel.log";	/* name of the logfile */


	/* Open a new Logfile or overwrite the existing one. */
	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	printf("## Repetitions: %3d                       ####\n",REPETITIONS);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing omp_in_parallel\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	fprintf(logFile,"## Repetitions: %3d                       ####\n",REPETITIONS);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing omp_in_parallel\n\n");

	for ( i = 0; i < REPETITIONS; i++ ) {
		fprintf (logFile, "\n\n%d. run of orph_test_omp_in_parallel out of %d\n\n",i+1,REPETITIONS);
		if(orph_test_omp_in_parallel(logFile)){
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

void orph1_omp_in_parallel (FILE * logFile) {
	    serial = omp_in_parallel ();
	
}

void orph2_omp_in_parallel (FILE * logFile) {
		isparallel = omp_in_parallel ();
	    
}
/* End of automatically generated definitions */
