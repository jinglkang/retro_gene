#!/usr/bin/perl -w

#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,
#NM_003856       +       Hs.66   231     1217

open OUT, ">$ARGV[2]"||die "!";
open Nofound, ">$ARGV[2].with.no.ugid"||die "!";

#print "\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";

my %hash_ugid=();
my %hash_start=();
my %hash_end=();
my %hash_map=();

open List, "$ARGV[0]"||die "!";
while (<List>) {#把list装入hash
	chomp;
	my @tmp=split;
	$hash_ugid{$tmp[0]}=$tmp[2];
	$hash_start{$tmp[0]}=$tmp[3];
	$hash_end{$tmp[0]}=$tmp[4];

}
close List;

#print "+++++++++++++++++++";

open Map, "$ARGV[1]"||die "!";
while (<Map>) {#把map信息装入hash
	chomp;
	my @tmp=split;
	#$hash_map{$tmp[10]}=$_;
	if (exists $hash_ugid{$tmp[10]}) {
		print OUT "$_\t$hash_ugid{$tmp[10]}\t$hash_start{$tmp[10]}\t$hash_end{$tmp[10]}\n";}
	else {print Nofound "$_\n";}
}
close Map;


#print "---------------------";

#while (my $map_line=<Map>) {
#	chomp $map_line;
#my @map_infor=split /\t/, $map_line;
#my $map_name=$map_infor[10];
#print OUT $map_line,"\t$hash_ugid{$map_name}\t$hash_start{$map_name}\t$hash_end{$map_name}";
#	#my $map_strand=$map_infor[9];
#	
#
#foreach my $key (keys %hash_list) {
#	if ($map_name eq $key) {
#		print OUT $map_line,"\t$hash_ugid{$key}\t$hash_start{$key}\t$hash_end{$key}\n"; $tag{$map_name}=1;last;#下一个map记录
#	}
#	else {next;}
#}
#if (!exists $tag{$map_name}) {
#	print Nofound $map_line,"\n"; #输出不在UniGene里的的est或refseq的map信息
#	}
#}


close Nofound;
close OUT;
exit