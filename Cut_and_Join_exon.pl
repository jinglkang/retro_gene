#!/usr/bin/perl -w

#BC065205,1       NM_201545       -       33736   33844   109
#BC065205,2       NM_201545       -       35318   35476   159
#BC065205,3       NM_201545       -       36335   36489   155


#>NM_000016
#CCGGCGCCGGGGACCGCTGccaccccgcctagcgcagcgccccgtccttccgcagcccaa
#ccgcctcttcccgccccgccccatcccgcccACGGGCTCCAGTGGGCGGGACCAGAGGAG
#TCCCGCGTTCGGGGAGTATGTCAAGGCCGTGACCCGTGTATTATTGTCCGAGTGGCCGGA
#ACGGGAGCCAACATGGCAGCGGGGTTCGGGCGATGCTGCAGGGTGAGAGGGAGCCCAGCG

#由于在切取GC序列的时候，已按照ref的方向切取，因此，若est的序列比到GC的负链，肯定是est本身方向有错，所以在这里不靠虑正负方向，都按正链考虑

open EST, "$ARGV[0]"||die "can not open $ARGV[0]\n";
open GC, "$ARGV[1]"||die "can not open $ARGV[1]\n";
open OUT, ">$ARGV[2]"||die "can not open $ARGV[2]\n";#输出连接好的est序列
open OUT2, ">$ARGV[3]"||die "!";#输出单独的exon序列
open Format,">format.tmp"||die "!";

my $est_name;
my %hash_format=();
my $last_size=0;
my $last_end=0;
while (my $in_line=<EST>) {#将est的exon位置信息都读入
	my @infor=split /\s+/,$in_line;
	$est_name=$infor[0];
	$est_name=(split /,/, $infor[0])[0];

	if (exists $hash_format{$est_name}) {$hash_format{$est_name}.="\t$infor[0]\t$infor[2]\t";$hash_format{$est_name}.=(1+$last_end);$last_end+=$infor[5];}
	else {$hash_format{$est_name}=">$est_name\t$infor[1]\t$infor[0]\t$infor[2]\t1";$last_end=$infor[5];}
}

foreach my $key (keys %hash_format) {
	print Format $hash_format{$key},"\n";
}

close EST;

my %hash_gc=();
#my %hash_tag=();

my $name;

while (my $gc_line=<GC>) {#读入GC序列不含提示符的行的
	chomp $gc_line;
	if ($gc_line=~/^>(\w+)/) {
		$name=$1;
		#print $name;
		$name=~s/>//;
	}
	else {$hash_gc{$name}.=$gc_line;}
}

open EST, "$ARGV[0]"||die "can not open $ARGV[0]\n";
my %est_exon_seq=();
my %hash_est=();
#my %hash_est_tag=();

while (my $est_line=<EST>) {
my @tmp=split /\s+/,$est_line;
$est_name=$tmp[0];
$est_name=(split /,/, $tmp[0])[0];
my $size=$tmp[4]-$tmp[3]+1;
if (!exists $hash_gc{$tmp[1]}) {next;}
$est_exon_seq{$tmp[0]}=substr($hash_gc{$tmp[1]}, $tmp[3]-1,$size);

$hash_est{$est_name}.=$est_exon_seq{$tmp[0]};


print OUT2 ">$tmp[0]\t$tmp[1]\t$tmp[2]\n$est_exon_seq{$tmp[0]}\n";

}


foreach my $key (keys %hash_est) {
	#print $hash_est{$key};
	#if (exists $hash_est_tag{$key}) {$hash_est{$key}=~tr/atcgATCG/tagcTAGC/;$hash_est{$key}=reverse $hash_est{$key};}
	print OUT "$hash_format{$key}\n$hash_est{$key}\n";
	
	}

close GC;
close Format;
close EST;
close OUT;
close OUT2;
exit