#!/usr/bin/perl -w

open MAP, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT1, ">findbest.tmp1"||die "can not open \n";
open OUT2, ">findbest.tmp2"||die "can not open \n";
#open Est_gc, ">$ARGV[1]"||die "!";

open Refpos, ">$ARGV[1]"||die "!";


my %hash_tag=();
my %tmp=(); #保存第一次出现的记录
#1293	432	3	0	0	1	1	2	6411	+	AL137623	624	0	436	chr9	138429268	92919800	92926646	4	30,132,266,7,	0,30,162,429,	92919800,92921307,92926373,92926639,	Hs.2	2	678

while (my $map_line=<MAP>) {
	my @infor=split /\s+/, $map_line;
	my $name=$infor[10];
	#my $hash_est{$name}=$_;
	if(!exists $hash_tag{$name}){$hash_tag{$name}=1; $tmp{$name}=$map_line;}
	else{$hash_tag{$name}++;print OUT2 $map_line;}

}
#print keys %hash_tag;
foreach my $key (keys %hash_tag) {
	if ($hash_tag{$key}==1) {
		print OUT1 $tmp{$key};      #将有冗余的输出到文件2，无冗余的输出到文件1
	}
	else {print OUT2 $tmp{$key};}
}


close MAP;
close OUT1;
close OUT2;

my %hash_est=();
my %hash_est_start=();
my %hash_est_end=();
my %hash_est_ugid=();
open MAP, "findbest.tmp1"||die "!";
while (my $map_line=<MAP>) {  #在非冗余的est里得到每一个unigene的起始和终止位置
	my @infor=split /\s+/,$map_line;
	#my $name=$infor[10];
	my $ugid=$infor[22];
	my $start=$infor[16];
	my $end=$infor[17];
	if (!exists $hash_est{$ugid}) {
		$hash_est{$ugid}=$map_line;
		$hash_est_start{$ugid}=$start;
		$hash_est_end{$ugid}=$end;
		$hash_est_ugid{$ugid}=$ugid;
		}
	else {
		if ($start<$hash_est_start{$ugid}) {$hash_est_start{$ugid}=$start;}
		if ($end>$hash_est_end{$ugid}) {$hash_est_end{$ugid}=$end;}
	}
}
close MAP;


#foreach my $key (keys %hash_est) {
#	print "$hash_est_start{$key}\t$hash_est_end{$key}\n";
#}

open MAP, "findbest.tmp2"||die "!";

while ($map_line=<MAP>) {
	my @infor=split /\s+/,$map_line;
	my $ugid=$infor[22];
	my $start=$infor[16];
	my $end=$infor[17];
#print "$start\t$end\t$hash_est_start{$ugid}\t$hash_est_end{$ugid}\n";
if(exists $hash_est{$ugid}){
	if ($start>$hash_est_end{$ugid} or $end<$hash_est_start{$ugid}) {next;}
	else {
		if ($start<$hash_est_start{$ugid}) {$hash_est_start{$ugid}=$start;}
		if ($end>$hash_est_end{$ugid}) {$hash_est_end{$ugid}=$end;}
	}
}
else {}



}
close MAP;

foreach my $key (keys %hash_est) {
	#print ">>>>>>>>>>>>>>";
	@infor=split /\s+/, $hash_est{$key};
	print Refpos "$infor[22]\t$hash_est_start{$key}\t$hash_est_end{$key}\n";
}

#close Est_gc;
close Refpos;
exit