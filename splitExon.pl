#!/usr/local/bin/perl -w

# sort -k2,2 -k4,4n -k5,5n
#AL545596,2	NM_000016	+	13266	13364	99	1
#CN277073,1	NM_000016	+	13267	13282	16	1
#AV690856,1	NM_000016	+	13267	13364	98	225
#CN277073,2	NM_000016	+	13345	13364	20	1

my $id = '';
my @r = ();
my $cnt = 0;
while(<>) {
	my @F = split;
	if($id ne $F[1]) {
		
		out(\@r);
		$id = $F[1];#同一refseq的才分割
		@r = ();
		$cnt = 0;
	}
	
	for(0..$#F) {
		$r[$cnt][$_] = $F[$_];#将同一基因所有的exon的所有记录读入2维数组r
		}
	$cnt++;

}
out(\@r);

sub out {
			my $id=1;
	my $r = shift;# $r是子函数输入数组的指针
	while(@$r > 0) {#只要输入不是空
		my ($st, $en) = ($$r[0][3], $$r[0][4]);#取位置信息
		(shift @$r) and next if($st > $en);
		
		for(@$r) {
			last if($$_[3] > $en);
			next if($$_[3] <= $st);
			$en = $$_[3]-1;
		}
		my $cnt = 0;
		
		for(0..$#$r) {
			last if($$r[$_][3] > $en);
			$cnt += $$r[$_][6] if($$r[$_][3]<=$st && $$r[$_][4]>=$en);
			$$r[$_][3] = $en+1 if($$r[$_][3] <= $en);
			}
		print "$$r[0][0]_$id\t$$r[0][1]\t$$r[0][2]\t$st\t$en\t", $en-$st+1, "\t$cnt\n";
	$id++;
	}
}
