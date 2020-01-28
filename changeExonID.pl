#!/usr/local/bin/perl -w

# sort -k2,2 -k4,4n -k5,5n
# exon_00000004   NM_007376_GC    -       3920    3940    21      constitutive    100.0   7


#exon_000001	NM_000153	-	200	300	100	constitute	100	4	6

my $id = '';
my @r = ();
while(<>) {
	my @F = split;
	if($id ne $F[1]) {
		out(\@r);
		$id = $F[1];
		@r = ();
	}
	push @r, $_;
}

out(\@r);

sub out {
	my $r = shift;
	my ($id, $st, $en, $cnt) = ('', 0, 0, 0);
	for(@$r) {
		my @F1 = split;
		if($F1[3] > $en) {
			($id, $st, $en, $cnt) = ($F1[1], $F1[3], $F1[4], $cnt+1);
		}
		my $sum = 0;
		for(@r) {
			my @F2 = split;
			next if($F1[3] > $F2[4]);
			next if($F2[3] > $F1[4]);
			$sum += $F2[8];
		}
		if($sum < $F1[8]) {
			print "$F1[0]\t$id", "_$cnt", "_S\n";
		} elsif($sum > $F1[8]) {
			print "$F1[0]\t$id", "_$cnt", "_A\n";
		} else {
			print "$F1[0]\t$id", "_$cnt", "\n";
		}
	}
}
