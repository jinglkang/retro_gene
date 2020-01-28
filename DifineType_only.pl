#!/usr/bin/perl -w

open List, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open OUT, ">$ARGV[1]"||die "can not open $ARGV[1]\n";
#NM_014625	chr1	-	1853	176255267	176255322	8	exon_3	56	70	1221		990		1045
#NM_144696	chr1	+	3408	176255303	176255524	26	exon_26	222	128	3166		3158	3379
#																	 cd-start cd-end	qstart qend
#																		9	 10          11      12
#给有overlap的exon定出类型
my %overlap_size=();
my %overlap_start=();
my %overlap_end=();
my @data=();

while (my $line_1=<List>) {
	chomp $line_1;
	my @infor_1=split /\t/, $line_1;
	my $q_start_1=$infor_1[9];
	
	my $q_end_1=$infor_1[10];

	my $start_1=$infor_1[4];
	my $end_1=$infor_1[5];
	my $name_1=$infor_1[0];
	
	my $line_2=<List>;
	chomp $line_2;
	my @infor_2=split /\t/, $line_2;
	my $q_start_2=$infor_2[9];
	my $q_end_2=$infor_2[10];
	my $start_2=$infor_2[4];
	my $end_2=$infor_2[5];
	my $name_2=$infor_2[0];


	if ($start_1 <= $start_2 and $end_1 >= $start_2 and $end_1 <= $end_2) {
		$overlap_size{$name_1}=abs($end_1-$start_2)+1;
		$overlap_size{$name_2}=abs($end_1-$start_2)+1;
		
		$overlap_start{$name_1}=$q_end_1-$overlap_size{$name_1}+1;
		$overlap_end{$name_1}=$q_end_1;
		$overlap_start{$name_2}=$q_start_2;
		$overlap_end{$name_2}=$q_start_2+$overlap_size{$name_2}-1;
		}
	
	elsif ($end_1 >= $end_2 and $start_1 <= $end_2 and $start_1 >= $start_2) {

		$overlap_size{$name_1}=abs($start_1-$end_2)+1;
		$overlap_size{$name_2}=abs($start_1-$end_2)+1;

		$overlap_start{$name_2}=$q_end_2-$overlap_size{$name_2}+1;
		$overlap_end{$name_2}=$q_end_2;
		$overlap_start{$name_1}=$q_start_1;
		$overlap_end{$name_1}=$q_start_1+$overlap_size{$name_1}-1;

		}
	
	elsif ($end_1 >= $end_2 and $start_1 <= $start_2) {

		$overlap_size{$name_1}=abs($end_2-$start_2)+1;
		$overlap_size{$name_2}=abs($end_2-$start_2)+1;
		
		my $size_left=abs($start_1-$start_2);
		my $size_right=abs($end_2-$end_1);

		$overlap_start{$name_2}=$q_start_2;
		$overlap_end{$name_2}=$q_end_2;
		$overlap_start{$name_1}=$q_start_1+$size_left;
		$overlap_end{$name_1}=$q_end_1-$size_right;
		

		}
	
	elsif ($end_1 <= $end_2 and $start_1 >= $start_2) {

		$overlap_size{$name_1}=abs($end_1-$start_1)+1;
		$overlap_size{$name_2}=abs($end_1-$start_1)+1;
		
		my $size_left=abs($start_1-$start_2);
		my $size_right=abs($end_2-$end_1);

		$overlap_start{$name_1}=$q_start_1;
		$overlap_end{$name_1}=$q_end_1;
		
		$overlap_start{$name_2}=$q_start_2+$size_left;
		$overlap_end{$name_2}=$q_end_2-$size_right;

		}
		else {
			print "wrong!!!!!!!!!!!!!!!!!!!!!\n";
			}
	
	print OUT "$line_1\t$overlap_size{$name_1}\t$overlap_start{$name_1}\t$overlap_end{$name_1}\n";
	print OUT "$line_2\t$overlap_size{$name_2}\t$overlap_start{$name_2}\t$overlap_end{$name_2}\n";

}

close List;

