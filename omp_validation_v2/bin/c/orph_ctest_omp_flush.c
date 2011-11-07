#include "omp_testsuite.h"


	int result1;
	int result2;
	int dummy;
    

/* Declaration of the functions containing the code for the orphan regions */
#include <stdio.h>


/* End of declaration */


#include <stdio.h>
#include <unistd.h>

#include "omp_testsuite.h"
#include "omp_my_sleep.h"

int orph_ctest_omp_flush (FILE * logFile)
{
    

	result1 = 0;
	result2 = 0;

#pragma omp parallel
    {
	int rank;
	rank = omp_get_thread_num ();

#pragma omp barrier
	if (rank == 1) {
	    result2 = 3;
	    
		
		dummy = result2;
	    
	}

	if (rank == 0) {
	    
	    
		
		result1 = result2;
	    
	}
    }	/* end of parallel */

    return ((result1 == result2) && (result2 == dummy) && (result2 == 3));
}
int main()
{
	int i;			/* Loop index */
	int result;		/* return value of the program */
	int failed=0; 		/* Number of failed tests */
	int success=0;		/* number of succeeded tests */
	static FILE * logFile;	/* pointer onto the logfile */
	static const char * logFileName = "bin/c/orph_ctest_omp_flush.log";	/* name of the logfile */


	/* Open a new Logfile or overwrite the existing one. */
	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	printf("## Repetitions: %3d                       ####\n",REPETITIONS);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing omp flush\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V %s ######\n", OMPTS_VERSION );
	fprintf(logFile,"## Repetitions: %3d                       ####\n",REPETITIONS);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing omp flush\n\n");

	for ( i = 0; i < REPETITIONS; i++ ) {
		fprintf (logFile, "\n\n%d. run of orph_ctest_omp_flush out of %d\n\n",i+1,REPETITIONS);
		if(orph_ctest_omp_flush(logFile)){
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

void orph1_omp_flush (FILE * logFile) {
		
		dummy = result2;
	    
}

void orph2_omp_flush (FILE * logFile) {
		
		result1 = result2;
	    
}
/* End of automatically generated definitions */
