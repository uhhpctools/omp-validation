# Fujitsu Compilers:
#CC = fcc
#CFLAGS = -KOMP,fast_GP2=2

# PGI compilers
#
#CC = pgcc
#CFLAGS = -fast -mp 

# Intel compilers:
#
#CC = ecc
CC = icc
#CC = omcc
#CFLAGS = -O3 -ip -openmp
#CFLAGS = -Wall -O0 -openmp
CFLAGS =  -openmp -lm

# Omni compilers:
#
#CC = ompcc
#CFLAGS = -O3 -lm 

# Assure compilers:
#
#CC = assurec
#CFLAGS = -O3 -WApname=project -DUSE_ASSURE=1

# NEC:
#
#CC = c++ 
#CC = sxc++ 
#CFLAGS = -Popenmp

#
# Hitachi:
#
#CC = xcc 
#CFLAGS = -O4 -pvec +Op -parallel -omp
#
# SGI:
#
#
#CC = cc
#CFLAGS = -mp -lm 

# IBM compilers:
#CC = xlc_r
#CFLAGS = -qsmp=omp -lm
#
# SUN compilers
#CC = cc
#CFLAGS = -fast -xopenmp -xvpara -lm
#
# open64 compilers
# remark: -I. was a workaround because the installation came without omp.h file
#CC = opencc
#CFLAGS = -O0 -openmp -lm -I. -lomp -lpthread


default: omp_testsuite.h
	make test1



omp_testsuite.h:
	./ompts_makeHeader.pl


test1:
	./ompts_parser.pl templates/omp_for_ordered.tpl -test
	./ompts_parser.pl templates/omp_for_ordered.tpl -crosstest
	icc -openmp -o test_omp_for_ordered test_omp_for_ordered.c
	icc -openmp -o crosstest_omp_for_ordered crosstest_omp_for_ordered.c


clean:
	-rm orphaned* test_* crosstest_* *.out *.log 
