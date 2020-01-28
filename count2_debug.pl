#!/usr/local/bin/perl -w

#AK093140,8      NM_152589       +       47272   47388   117     3
open OUT ,">exon_est.realtion"||die "!";
my %hash_relation;
my %hash_est_count;
my %hash_exon_count;
my $list = shift; #数据文件附给$list
open(LIST, $list) || die "cannot open the file $list\n";
my %hash = ();
while(<LIST>) {
	my @F = split;
	$hash{$F[1]} .= "$F[0]\t$F[1]\t$F[3]\t$F[4]\n";#以Q_name为key,将属于同一GC的est的起始和终止信息全部给全局变量%hash
}

while(<>) {#从标准输出拿信息文件 test.ExonPos.merge60bp.xls
	chomp;
	my @F = split;
	#exon0001	NM_000153	-	87476002	87476078	77	3

	my $cnt = 0;
	for(split(/\n/, $hash{$F[1]})) {
		my ( $est_name, $ref_name,$st, $en ) = split; #将起始信息给$st,终止信息给$en
		$cnt++ if($st<=$F[3] && $en>=$F[4]);#若
		if($st<=$F[3] && $en>=$F[4]){$hash_relation{$F[0]}.="$F[0]\t$est_name\t$ref_name\t$st\t$en\n";}
	}
	$hash_est_count{$F[0]}=$cnt;
	$hash_exon_count{$F[0]}=$F[6];
	print "$_\t$cnt\n";
}

foreach my $key (keys %hash_relation) {
		print OUT ">>>\t$key\t$hash_exon_count{$key}\t$hash_est_count{$key}\n";
		print OUT $hash_relation{$key};

}