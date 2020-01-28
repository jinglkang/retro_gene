#!/usr/bin/perl

open (IN,"$ARGV[0]")||die;
open (OUT,">$ARGV[1]")||die;

#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,	Hs.404056	61	837


while (<IN>) {
	chomp;
my @infor=split;
if (($infor[1]+$infor[3])/$infor[11]>0.95) {
	print OUT $_,"\n";#match的有2部分，非repeat和repeat,去除identity<0.95的，可能是旁系同源
}
}

close IN;
close OUT;
exit


##对于一个refseq有多个hit的情况，只保留match最好的输出,并将冗余的输出.extra文件
#open (TMP,"findbest.tmp")||die;
#
#my %best_result=();
#my %best=();
#
#while (<TMP>) {
#	
#	if ($_ =~/^\d/) {
#		chomp;
#		my @infor=split;
#		my $match=($infor[1]+$infor[3])/$infor[11];
#		my $name=$infor[10];
#		#print ">>>>>>>>>>>>>>>>$match\n";
#	if (exists $best_result{$name}) {
#			if ($best{$name}<$match) {
#				print OUT2 $best_result{$name},"\n";
#				$best{$name}=$match;
#				$best_result{$name}=$_;
#				 
#				}
#
#			elsif ($best{$name}>=$match) {print OUT2 $_,"\n";}
#			
#			
#			}
#		
#		else {
#			$best{$name}=$match;
#			$best_result{$name}=$_;
#		}
#	}
#}

#foreach my $key (keys %best_result) {
#	print OUT $best_result{$key},"\n";
#}

