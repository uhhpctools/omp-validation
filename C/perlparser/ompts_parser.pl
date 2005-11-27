#!/usr/bin/env perl

# ompts_parser [option] SOURCEFILE
# 
# Creats the tests and the crosstests for the OpenMP-Testsuite out of an templatefiles which are given to the programm.
# 
# Options:
# -test: 		make test
# -crosstest: 	make crosstest
# -orphan		if possible generate tests using orphan regions (not implemented yet)
# -o=FILENAME	outputfile (only when one templatefile is specified)


# Using Getopt::long to extract the programm options
use Getopt::Long;
# Using functions: Set of subroutines to modify the testcode
use ompts_parserFunctions;

# Getting given options
GetOptions("-test" => \$test,"-crosstest" => \$crosstest, "-o=s" => \$outputfile, "-orphan" => \$orphan, "-f!");

# Remaining arguments are the templatefiles. 
# Adding these to the list of to be parsed files if they exist.
foreach $file(@ARGV)
{
	if(-e $file){ 
		push(@sourcefiles,$file); 
	}
	else
	{
		print "Error: Unknown Option $file\n";
	}
}
	
# Checking if options were valid:
if(@sourcefiles == 0){die "No files to parse are specified!";}
if($outputfile && (@sourcefiles != 1 || ($test && $crosstest) ) ){die "There were multiple files for one outputfiles specified!";} 
if($orphan){
    $orphanprefix = "orphaned";
}
else {
    $orphanprefix = "";
}
    

# Reading the templates for the tests into @sources
foreach $srcfile (@sourcefiles)
{
	# Reading the content of the current sourcefile	into $src
	open(TEST,$srcfile) or print "Error: Could not open template $srcfile\n";
	while(<TEST>){
		$src .= $_;
	}
	close(TEST);
	# Adding the content $src to the end of the list @sources
	push(@sources,$src);
}

# Extracting the source for the mainprogramm and saving it in $mainprocsrc
$mainprocsrc = "ompts_standaloneProc.c";
open(MAINPROC,$mainprocsrc) or die "Could not open the sourcefile for the main program $mainprocsrc";
while(<MAINPROC>){
	$mainproc .= $_;
}


foreach $src(@sources)
{
	# Some temporary testinformation:
	($description) = get_tag_values('ompts:testdescription',$src);
	($directive) = get_tag_values('ompts:directive',$src);
	($functionname) = get_tag_values('ompts:testcode:functionname',$src);


	# Creating the source for the test:
	if($test)
	{
		open(OUTFILE,">".$orphanprefix."test_".$functionname.".c") or die("Could not create the output file for $directive");
		($code) = get_tag_values('ompts:testcode',$src);
		# Make modifications for the orphaned testversion if necessary:
		if($orphan)
		{
			# Create declarations for orphan vars:
			$orphvarsdef = make_global_vars_def($code);
			# Generate predeclarations for orpahn functions:
			$orphfuncsdefs = orph_functions_declarations('test_',$code);
			# Generate the orphan functions:
			$orphfuncs = create_orph_functions('test_',$code);
			# Replace orphan regions by functioncalls:
			($code) = orphan_regions2functions( 'test_', ($code) );
			# Deleting the former declarations of the variables in the orphan regions:
			($code) = delete_tags('ompts:orphan:vars',($code));
			# Put all together:
			$code = $orphvarsdef . $orphfuncsdefs . $code . $orphfuncs;
		}
		# Remove the marks for the orpahn regions and its variables:
		($code) = enlarge_tags('ompts:orphan','','',($code));
		($code) = enlarge_tags('ompts:orphan:vars','','',($code));
		# Remove the marks for the testcode:
		($code) = enlarge_tags('ompts:check','','',($code));
		# Removing the code for the crosstest:
		($code) = delete_tags('ompts:crosscheck',($code));		
		# Putting together the functions and the mainprogramm:
		$code .= $mainproc;
		# Making some final modifications:
		($code) = replace_tags('testfunctionname',"test_$functionname",($code));
		($code) = replace_tags('directive',$directive,($code));
		($code) = replace_tags('description',$description,($code));
		($code) = enlarge_tags('ompts:testcode:functionname','test_','',($code) );
		$code =  "\#include \"omp_testsuite.h\"\n".$code;
		# Write the result into the file and close it:
		print OUTFILE $code;
		close(OUTFILE);
	}
	
	# Creating the source for the crosstest:
	if($crosstest)
	{
		open(OUTFILE,">".$orphanprefix."crosstest_".$functionname.".c") or die("Could not create the output file for $directive");
		($code) = get_tag_values('ompts:testcode',$src);
		# Make modifications for the orphaned crosstestversion if necessary:
		if($orphan)
		{
			# Create declarations for orphan vars:
			$orphvarsdef = make_global_vars_def($code);
			# Generate predeclarations for orpahn functions:
			$orphfuncsdefs = orph_functions_declarations('crosstest_',$code);
			# Generate the orphan functions:
			$orphfuncs = create_orph_functions('crosstest_',$code);
			# Replace orphan regions by functioncalls:
			($code) = orphan_regions2functions( 'crosstest_', ($code) );
			# Deleting the former declarations of the variables in the orphan regions:
			($code) = delete_tags('ompts:orphan:vars',($code));
			# Put all together:
			$code = $orphvarsdef . $orphfuncsdefs . $code . $orphfuncs;
		}
		# Remove the marks for the orpahn regions and its variables:
		($code) = enlarge_tags('ompts:orphan','','',($code));
		($code) = enlarge_tags('ompts:orphan:vars','','',($code));
		# Remove the marks for the crosstestcode:
		($code) = enlarge_tags('ompts:crosscheck','','',($code));
		# Removing the code for the test:
		($code) = delete_tags('ompts:check',($code));		
		# Putting together the functions and the mainprogramm:
		$code .= $mainproc;
		# Making some final modifications:
		($code) = replace_tags('testfunctionname',"crosstest_$functionname",($code));
		($code) = replace_tags('directive',$directive,($code));
		($code) = replace_tags('description',$description,($code));
		($code) = enlarge_tags('ompts:testcode:functionname','crosstest_','',($code) );
		$code =  "\#include \"omp_testsuite.h\"\n".$code;
		# Write result into the file and close the it:
		print OUTFILE $code;
		close(OUTFILE);
	}
}
