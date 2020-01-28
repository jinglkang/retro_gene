#!/usr/bin/perl

open (A,"$ARGV[0]")||die;
my $i=0;
while (<A>) {
	chomp;
	@tmp=split(/\t/,$_);
	$i++;
	push (@star_end,$tmp[2],$tmp[3]);
	$hash{$i}=$_;
	$loc{$i}=$tmp[1];
}

foreach $i (sort keys %hash) {
	if ($loc{$i+1} eq $loc{$i}) {
		if (($star_end[2*($i+1)-3]-$star_end[2*($i+1)-2])/($star_end[2*($i+1)-3]-$star_end[2*($i+1)-4])>0.1 ||($star_end[2*($i+1)-3]-$star_end[2*($i+1)-2])/($star_end[2*($i+1)-1]-$star_end[2*($i+1)-2])>0.1) {
			print $hash{$i},"\t","\-","\t",$hash{$i+1},"\t";
			if (($star_end[2*($i+1)-3]-$star_end[2*($i+1)-4])-($star_end[2*($i+1)-1]-$star_end[2*($i+1)-2])>0) {
				print "====","\t",$hash{$i},"\t","----","\t",$hash{$i+1},"\n";
			}
			else{
				print "====","\t",$hash{$i+1},"\t","----","\t",$hash{$i},"\n";
			}
		}
	}
}