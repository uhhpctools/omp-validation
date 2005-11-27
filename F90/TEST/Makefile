#
# By Chunhua Liao
# University of Houston
#
#-------------------------------------------------
#Set the desired compiler and options 
#change NUM_THREADS to the proper one on your machine
#-------------------------------------------------

NUM_THREADS=2
#SUN Fortran Compiler:
#FC=f90
#FFLAGS=-xopenmp -O3 -g
#FLINKFLAGS=-O3 -xopenmp -g

#
#Intel Compiler
#FC=ifort
#FFLAGS=-openmp -O3
#FLINKFLAGS=-O3 -openmp
#
# Fujitsu Compiler
#FC=frt
#FFLAGS=-KOMP,fast_GP2=2 -w -Am -X9 -Fixed
#FLINKFLAGS=-KOMP,fast_GP2=2 -w -Am
#
#IBM Compiler
#FC=xlf90_r
#FFLAGS=-qsmp=omp -qfixed=132 -qlanglvl=extended
#FLINKFLAGS=-qsmp=omp -lm
#
#PGI Compiler
#FC=pgf90
#FFLAGS=-fast -mp
#FLINKFLAGS=-fast -mp
#
#Pathscale Compiler
#FC=pathf90
#FFLAGS= -mp -Ofast -lm
#FLINKFLAGS=-mp -Ofast -lm
#
#Open64 Compiler
#FC=openf90
#FFLAGS=  -Ofast -mp
#FLINKFLAGS=-Ofast -mp
#
#ORC Compiler
#FC=orf90
#FFLAGS= -mp
#FLINKFLAGS= -mp

#-------------------------------------------------
# No need to change anything below usually
#--------------------------------------------------
ifdef testfile
TESTFILE = $(testfile)
endif

ifdef TESTFILE
TEST_FILENAME = $(TESTFILE)
else
TEST_FILENAME = ALL_TEST
endif

.PHONEY:print_help
print_help:
	@echo "--------------------------------------------------------"
	@echo "1. Edit Makefile for proper compiler command and options"
	@echo "--------------------------------------------------------"
	@echo "2. Run tests: "
	@echo "     gmake run"
	@echo "     gmake run TESTFILE=filename"
	@echo "where filename may be one of the following:"
	@echo "   OMP1_TEST - execute omp version 1 tests"
	@echo "   OMP2_TEST - execute omp version 2 tests"
	@echo "   ALL_TEST  - execute all above tests(the default one)"
	@echo "   CUSTOM_TEST - execute a configurable subset of the tests"
	@echo "--------------------------------------------------------"
	@echo "3. Clean up first before any new exectuion:"
	@echo "     gmake clean "
	@echo "--------------------------------------------------------"

default:print_help

.PHONY: test
test:main

# precompilation tries to generate .o files for feasible tests
# A header is generated from available .o files
mainBody.f:
	./preCompilation $(TEST_FILENAME) $(FC) $(FFLAGS)

#compile main.c and link with other objects to get the executable
main:mainBody.f 
	$(FC) $(FFLAGS) $(FLINKFLAGS) -o main main.f *.o

%.o:%.f
	$(FC) -c $(FFLAGS) $< -o $@

.PHONY:clean
clean:
	rm -f main *.o testdeclarations.f  mainBody.f test.log failed.compilation
.PHONY:run
run:clean main
	(OMP_NUM_THREADS=$(NUM_THREADS); export OMP_NUM_THREADS; ./main)
