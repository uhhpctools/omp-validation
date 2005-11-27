#by Chunhua Liao
# Nov 27, 2005
include Makefile.override

C_BUILD_DIR = C/TEST
F90_BUILD_DIR = F90/TEST

C_COMPONENTS = $(C_BUILD_DIR)/main
F90_COMPONENTS = $(F90_BUILD_DIR)/main

BUILD_COMPONENTS = $(C_COMPONENTS) $(F90_COMPONENTS)
.PHONY: all f90 c clean

all:c f90

f90:$(F90_COMPONENTS)
#	cd F90/TEST ; gmake run
	gmake -C $(F90_BUILD_DIR) run
c:$(C_COMPONENTS)
#	cd $(F90_BUILD_DIR) && gmake run
	gmake -C $(C_BUILD_DIR) run
clean:
	gmake -C $(F90_BUILD_DIR) clean
	gmake -C $(C_BUILD_DIR) clean
