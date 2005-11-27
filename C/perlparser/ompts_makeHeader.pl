#!/usr/bin/perl -w

# ompts_makeHeader [options] [dirs]
#
# Creats the headerfile for the OpenMP-Testsuite out of the templatefiles 
# witch are in the default/explicitely specified dir and the settings in the
# ompts.conf file in the main directory.
#
# dirs:
# 	Specifies the dir with the templatefiles. Default is "./templates"
# 
# options:
# -f=FILENAME: Using file FILENAME as configfile instead of the default (ompts.conf)
# -i=FILENAME: Include other Headerfile. The files to be included must be specified
# after setting this option. (Not implemented yet.)
# 
# -o=FILENAME: outputfilename (default is "omp_testsuite.h")

$headerfile = "\/\* Global headerfile of the OpenMP Testsuite \*\/\n\n\/\* This file was created with the ompts_makeHeder.pl script using the following opions:\ *\/\n\/\* ";
if(@ARGV > 0)
{
	foreach $opt (@ARGV)
	{
		$headerfile .= "$opt ";
	}
}
else
{
	$headerfile .= "No options were specified";
}

$headerfile .=" \*\/\n\n\n";

use Getopt::Long;
GetOptions("-o=s" => \$outfile, "-f=s" =>\$configfile);

if(!$outfile){
	$outfile = "omp_testsuite.h";	# setting default value for the headerfile
}

if(!$configfile) {	
	$configfile = "ompts.conf"; 	# setting default value for the configfile 
}	

$templatedir = "./templates";	# dir holding the templates

#@includefiles;					# list holing extra includefiles specified by the user 


# generating the head of the includeguard:
$headerfile .= "\#ifndef OMP_TESTSUITE_H\n\#define OMP_TESTSUITE_H\n\n";

# inserting general settings out of ompts.conf:
open(OMPTS_CONF,$configfile) or die "Could not open the global config file $configfile.";
while(<OMPTS_CONF>){
	$headerfile .= $_;
}
close(OMPTS_CONF);

# searching the tests:
opendir TEMPLATEDIR, "./templates" or die "Could not open dir.";
@templates = grep /(.*)\.tpl/, readdir TEMPLATEDIR;
closedir TEMPLATEDIR;

# inserting the function declarations:
foreach $template (@templates){
	$source = "";
	open(TEMPLATE,$templatedir."/".$template) or die "Could not open the following sourcefile: ".$templatedir."/".$template;
	while(<TEMPLATE>){
		$source .= $_;
	}
	close(TEMPLATE);
	$source =~ /\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>/;
	$functionname = $1."(FILE \* logfile);";
	$source =~ /\<ompts\:directive\>(.*)\<\/ompts\:directive\>/;
	$directive = $1;
	$headerfile .= "int test_".$functionname."  /* Test for ".$directive." */\n";
	$headerfile .= "int crosstest_".$functionname."  /* Crosstest for ".$directive." */\n";
}

# inserting the end of the includeguard:
$headerfile .= "\n#endif";

# craeting the headerfile:
open(OUTFILE,">".$outfile) or die "Could not create the haedaerfile ($outfile)";
print OUTFILE $headerfile."\n";
close(OUTFILE);

