int main()
{
	int i,result;
	int failed=0, success=0;
	int N=REPETITIONS;
	static FILE * logFile;
	static const char * logFileName = "<testfunctionname></testfunctionname>.log";


	logFile = fopen(logFileName,"w+");

	printf("######## OpenMP Validation Suite V 0.94 ######\n");
	printf("## Repetitions: %3d                       ####\n",N);
	printf("## Loop Count : %6d                    ####\n",LOOPCOUNT);
	printf("##############################################\n");
	printf("Testing <directive></directive>\n\n");

	fprintf(logFile,"######## OpenMP Validation Suite V 0.94 ######\n");
	fprintf(logFile,"## Repetitions: %3d                       ####\n",N);
	fprintf(logFile,"## Loop Count : %6d                    ####\n",LOOPCOUNT);
	fprintf(logFile,"##############################################\n");
	fprintf(logFile,"Testing <directive></directive>\n\n");

	for(i=0;i<N;i++){
		if(<testfunctionname></testfunctionname>(logFile)){
			fprintf(logFile,"Test succesfull.\n");
			success++;
		}
		else {
			fprintf(logFile,"Error: Test failed.\n");
			printf("Error: Test failed.\n");
			failed++;
		}
	}

    if(failed==0){
		fprintf(logFile,"\nDirectiv worked without errors.\n");
		printf("Directiv worked without errors.\n");
		result=0;
	}
	else{
		fprintf(logFile,"\nDirective failed the test %i times out of %i. %i were successful\n",failed,N,success);
		printf("Directive failed the test %i times out of %i.\n%i test(s) were successful\n",failed,N,success);
		result=failed;
	}
	return result;
}
