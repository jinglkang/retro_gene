#!/usr/bin/perl -w

use strict;
use Getopt::Long;
open IN,"$ARGV[0]" || die"$!";
open OUT,">$ARGV[1]" || die"$!";

#NAME	CHR	S	A	P	KS	KA	KI	KP	DETBRAIN	DETHEART	DETKIDNEY	DETLIVER	DETTESTIS	CHBRAIN	CHHEART	CHKIDNEY	CHLIVER	CHTESTIS	RMABRAIN	RMAHEART	RMAKIDNEY	RMALIVER	RMATESTIS	VARBRAIN	VARHEART	VARKIDNEY	VARLIVER	VARTESTIS
#101F6	3	215.3	450.7	1644	0.0088	0.0024	0.01014	0.0097	1	1	1	1	1	0	0	0	0	0	0.0212	0.1420	0.1069	0.1178	0.0560	0.0220	0.0679	0.1186	0.1251	0.0169
#182-FIP	17	714.7	1364.3	1480	0.0042	0.0015	0.01077	0.0047	1	1	1	1	1	0	0	0	0	1	0.1017	0.1965	0.4362	0.4807	0.1634	0.0662	0.1988	0.1822	0.4068	0.0368


my %brain;
my %heart;
my %kidney;
my %liver;
my %testis;

while (<IN>) {
	chomp;
	if (/^NAME/) {next;}
	my @infor=split /\t/,$_;
	#print "$infor[5]";
	my $name=$infor[0];
	if ($infor[14]==1) {$brain{$name}=1;}
	if ($infor[15]==1) {$heart{$name}=1;}
	if ($infor[16]==1) {$kidney{$name}=1;}
	if ($infor[17]==1) {$liver{$name}=1;}
	if ($infor[18]==1) {$testis{$name}=1;}
}

foreach my $key (keys %testis) {
	print OUT "$key\n";
}
