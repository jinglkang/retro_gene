#!/usr/bin/perl -w

#有冗余的输入到文件2，uniq的输入到文件1
open MAP, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT1, ">findbest.tmp1"||die "can not open \n";
open OUT2, ">findbest.tmp2"||die "can not open \n";

#1293	432	3	0	0	1	1	2	6411	+	AL137623	624	0	436	chr9	138429268	92919800	92926646	4	30,132,266,7,	0,30,162,429,	92919800,92921307,92926373,92926639,	Hs.2	2	678
my %hash_tag=();
my %tmp=(); #保存第一次出现的记录

while (my $map_line=<MAP>) {
	my @infor=split /\s+/, $map_line;
	my $name=$infor[10];
	
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