# General Makefile containing all the necessary compiler flags for the tests

# modify CC and CFLAGS for OpenMP C compilers
# modify FC and FFLAGS for OpenMP Fortran compilers


# Content:
#########################################################
 
# 1. Basic usage
# 2. General testsuite settings
# 3. Compiler selection and Flags

#########################################################


#########################################################
# 1. Basic usage
#########################################################
# 	make ctest		generate c test "ctest"
# 	make ftest		generate fortran test "ftest"
#	make clean		removes all sources and binaries
# 	make cleanall	removes sources,binaries and logfiles


#########################################################
# 2. General testsuite settings
#########################################################

# For general testsuite settings see the configuration file
# ompts.conf

#########################################################
# 3. Compiler selection and Flags
#########################################################

# GNU Compiler
#CC     = gcc
#CFLAGS = -fopenmp -lm
#CFLAGS = -fopenmp -lm -O3
#FC     = gfortran
#FFLAGS = -fopenmp -lm -I/home/shaunak/V2/
#FFLAGS = -fopenmp -lm -O3



#CC=icc
#CFLAGS=-openmp

# Fujitsu Compilers:
#CC = fcc
#CFLAGS = -KOMP,fast_GP2=2
#FC=frt
#FFLAGS=-KOMP,fast_GP2=2 -w -Am -X9 -Fixed


# PGI compilers
#CC = pgcc
#CFLAGS = -mp
#CFLAGS = -mp -DVERBOSE
#CFLAGS = -fast -mp

#FC = pgf90
#FFLAGS = -fast -mp
#FFLAGS = -mp -g


# Intel compilers:
#CC = ecc
#CC = icc
#CC = omcc
#CFLAGS = -O3 -ip -openmp
#CFLAGS = -Wall -O0 -openmp
#CFLAGS =  -openmp -lm
#CFLAGS =  -openmp -lm -DVERBOSE

#FC = ifort
#FFLAGS = -openmp -lm -fpp


# Omni compilers:
#CC = ompcc
#CFLAGS = -O3 -lm 


# Assure compilers:
#CC = assurec
#CFLAGS = -O3 -WApname=project -DUSE_ASSURE=1
#FC =
#FFLAGS =

# NEC:
#CC = c++ 
#CC = sxc++ 
#CFLAGS = -Popenmp

#FC=sxf90
#FFLAGS= -Popenmp


# Hitachi:
#CC = xcc 
#CFLAGS = -O4 -pvec +Op -parallel -omp
#FC =
#FFLAGS =


# SGI:
#CC = cc
#CFLAGS = -mp -lm 
#FC =
#FFLAGS =


# IBM compilers:
#CC = xlc_r
#CFLAGS = -qsmp=omp -lm


#FC=xlf90_r
#FFLAGS=-qsmp=omp -qfixed=132 -qlanglvl=extended


# SUN compilers
#CC = cc
#CFLAGS = -fast -xopenmp -lm

#FC =f90
#FFLAGS = -xopenmp -fast -lm


# open64 compilers
# remark: -I. was a workaround because the installation came without omp.h file
#CC = opencc
#CFLAGS = -O0 -openmp -lm -I. -lomp -lpthread 
#CFLAGS = -O0 -openmp -lm -I /home/matthew/opt/usr/include -lpthread
#CFLAGS = -openmp -lm

#FC = openf90
#FFLAGS = -O0 -openmp -lm  -lomp -lpthread


#Pathscale Compiler
#CC = pathcc
#CFLAGS = -mp -Ofast -lm

#FC=pathf90
#FFLAGS= -mp -Ofast -lm


#OpenUH Compiler
CC = uhcc
CFLAGS = -gnu3 -mp

FC = uhf90
FFLAGS = -mp -I/home/shaunak/V2/


omp_my_sleep: 
	mkdir -p bin/c
	cp omp_my_sleep.h bin/c/
omp_testsuite: omp_testsuite.h
	mkdir -p bin/c
	cp omp_testsuite.h bin/c/
omp_testsuite.h: ompts-c.conf c/*
	./ompts_makeHeader.pl -f=ompts-c.conf -t=c
.c.o: omp_testsuite omp_my_sleep
	$(CC) $(CFLAGS) -c $<

ctest: omp_my_sleep omp_testsuite
	./runtest.pl --lang=c testlist-c.txt

ftest:
	./runtest.pl --lang=fortran testlist-f.txt

print_compile_options:
	@echo "C compiler: $(CC)"
	$(CC) --version
	@echo "CFLAGS: $(CFLAGS)"
	@echo ""
	@echo "Fortran compiler: $(FC)"
	$(FC) --version
	@echo "FFLAGS: $(FFLAGS)"

cleansrcs:
	find bin/ -iname *.[cf] -exec rm {} \;
cleanbins:
	find bin/ -perm +111 -exec rm {} \;
cleanouts:
	find bin/ -iname *.out -exec rm {} \;
cleanlogs:
	find bin/ -iname *.log -exec rm {} \;
cleanall:
	rm -rf bin/

