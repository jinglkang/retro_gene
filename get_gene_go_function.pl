#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"!";

#<component>
# %cell  2718
#   Hs.10056

#catalytic activity	
#signal transducer activity	
#transcription regulator activity	
#transporter activity	

my $function;
my %hash;
while (<IN>) {
	chomp;
	if (/^</) {next;}
	if (/^\s%(.*)\t/) {
		$function=$1;
		#print "_____________$1\n";
		next;
	}
	$_=~s/\s//g;
	#print ">>>>>>>>$_\n";
	$hash{$_}.="$function\t";
}


my %num;
foreach my $key (keys %hash) {
	if ($hash{$key}=~/catalytic activity/) {$num{$key}++;}
	if ($hash{$key}=~/signal transducer activity/) {$num{$key}++;}
	if ($hash{$key}=~/transcription regulator activity/) {$num{$key}++;}
	if ($hash{$key}=~/transporter activity/) {$num{$key}++;}



}

my %num_fun;
my $total;
foreach my $key (keys %num) {
if ($num{$key}==1) {
	$total++;
	if ($hash{$key}=~/catalytic activity/) {$num_fun{"catalytic activity"}++;}
	if ($hash{$key}=~/signal transducer activity/) {$num_fun{"signal transducer activity"}++;}
	if ($hash{$key}=~/transcription regulator activity/) {$num_fun{"transcription regulator activity"}++;}
	if ($hash{$key}=~/transporter activity/) {$num_fun{"transporter activity"}++;}
}
}

foreach my $key (keys %num_fun) {
	print "$key\t$num_fun{$key}\t",$num_fun{$key}/$total*100, "\n";
}
