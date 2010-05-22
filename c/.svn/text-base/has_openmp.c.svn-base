<ompts:test>
<ompts:testdescription>Test which checks the OpenMp support.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>_OPENMP</ompts:directive>
<ompts:testcode>
#include <stdio.h>

#include "omp_testsuite.h"

int <ompts:testcode:functionname>has_openmp</ompts:testcode:functionname>(FILE * logFile){
    int rvalue = 0;
    <ompts:check>
#ifdef _OPENMP
	rvalue = 1;
#endif
    </ompts:check>
    <ompts:crosscheck>
#if 0
	rvalue = 1;
#endif
    </ompts:crosscheck>
	return (rvalue);
}
</ompts:testcode>
</ompts:test>
