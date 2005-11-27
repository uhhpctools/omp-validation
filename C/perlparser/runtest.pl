#!/usr/bin/env perl

# runtest [options] FILENAME
#
# Read the file FILENAME. Each line contains a test. 
# Convert template to test and crosstest. 
# If possilble generate orphaned testversions, too.
# Use make to compile the test
#
# Options:
# -norphan		do not generate orphaned test versions
# -maxthread=COUNT	run tests with a threadnumber from 2 up to COUNT
# -d=DIR		specify the directory containing the templates
#			default is templates
# -norun		only compile, no run
# -nocompile		do not compile, only run
# --help		print help
#

$results = "results.txt";
$dir = "templates";

# Using Getopt::long to extract the programm options
use Getopt::Long;

# Getting given options
GetOptions("--help" => \$help, "-norphan" => \$norphan,"-maxthread=i" => \$maxthread, "-norun" => \$norun, 
    "-nocompile" => \$nocompile, "-d=s" => \$dir, "-f!");
$testfile = $ARGV[0];

if($help){
    $helptext = "runtest [options] FILENAME\n
The runtest script reads the file FILENAME. Each line of this file has to
contain the name of a test. The script converts templates to tests and
crosstests. If possilble it generates orphaned testversions, too. Then it
compiles the source using make and runs finaly all tests.

Options:
-norphan              do not generate orphaned test versions
-maxthread=COUNT      run tests with a threadnumber from 2 up to COUNT
-d=DIR                specify the directory containing the templates
		      default is templates
-norun                only compile the tests, do no run them
-nocompile            do not compile the tests, only run them
--help                show this help\n";
    print $helptext;
    exit 0;
}

# Set maxthread if it was not specified with the program arguments
if(!($maxthread)){
    $maxthread = 2;
}
# Checking if given testfile exists
die "The specifeid testlist does not exist." if(!(-e $testfile));

# printing some Information
print "Running tests with maximal $maxthread threads.\n";
print "Using testlist $testfile for input.\n";
print "Using dir $dir to search testtemplates.\n";

# generating an up to date header file
print "Generating headerfile ...\n";
$cmd = "./ompts_makeHeader.pl $dir";
system($cmd);

print "Reading testlist ...\n";

open(TEST,$testfile) or die "Error: Could not open  $testfile\n";
open(RESULTS,">$results") or die "Error: Could not create  $results\n";

print RESULTS "\\ Number of Threads\t";
for($j=2; $j <= $maxthread; $j++){
    print RESULTS "$j\t\t\t\t";
}
print RESULTS "\nTested Directive";
for($j=2; $j <= $maxthread; $j++){
    print RESULTS "\tt\tct\tot\toct";
}
print RESULTS "\n";

    
while(<TEST>){
    $testname = $_;
    chomp($testname);
    print RESULTS "$testname\t";

    for($numthreads = 2; $numthreads <= $maxthread; $numthreads++){
	for($i=0; $i<2; $i++){
	    # Create templates:
	    $template = $dir."/".$testname.".tpl";

	    $cmd="grep -q ompts:orphan ".$template;
	    $orphanedtest=system($cmd);
	    if( ($i==1) && ($orphanedtest==0) && !($norphan) ){
		$orphanflag=" -orphan";
		$orphanname="orphaned";
	    } else {
		$orphanflag="";
		$orphanname="";
	    }	    
	    $failed = "-";
	    $crossresult = "-";
	    if( ($i==0) || (($orphanedtest==0) && !($norphan)) ){
		$cmd="./ompts_parser.pl ".$template." -test".$orphanflag;
		system($cmd);
		$cmd="./ompts_parser.pl ".$template." -crosstest".$orphanflag;
		system($cmd);

		# Compile:
		if(!$nocompile){
		    print "Creating source out of templates ... \n";
		    $cmd="make ".$orphanname."test_".$testname." >> compile.log";
		    system($cmd);
		    $cmd="make ".$orphanname."crosstest_".$testname." >> compile.log";
		    system($cmd);
		}
	    
		# Run the tests:
		if(!$norun){
		    print "Running test using $numthreads threads ... ";
		    $cmd = "OMP_NUM_THREADS=".$numthreads."; ./".$orphanname."test_".$testname."> test_".$testname.".out";
		    $exit_status = system($cmd);
		    if ($exit_status){
			print $testname.$orphanname." failed !!! " ;
			$failed = $exit_status >> 8;
			$failed=0
		    } else {
			print $testname.$orphanname." succeeded ";
			$failed=1
		    }

		    if(!$failed){
			print "\n";
		    } else {
			# Run the crosstest
			$cmd = "OMP_NUM_THREADS=".$numthreads."; ./".$orphanname."crosstest_".$testname."> crosstest_".$testname.".out";
			$exit_status = system($cmd);
			if ($exit_status){
			    $crossresult = $exit_status >> 8;
			    print " and was verified\n";
			    $crossresult=1;
			} else {
			    $crossresult=0;
			    print " but might just have been lucky\n";
			}
		    }
		    # clean up
		    # $cmd = "rm test_".$testname." crosstest_".$testname;
		    # system($cmd);
		}
	    }
	    print RESULTS $failed."\t".$crossresult."\t";
	}
    }
    print RESULTS "\n";
} # end of outer loop
close(RESULTS);
close(TEST);
