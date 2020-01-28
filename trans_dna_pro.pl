#!/usr/bin/perl


open (I,"$ARGV[0]")||die "open I error\n";

open (O,">$ARGV[1]");
 %matrix = ("TTT"=>"F","TTC"=>"F","TTA"=>"L","TTG"=>"L","TCT"=>"S","TCC"=>"S",
			"TCA"=>"S","TCG"=>"S","TAT"=>"Y","TAC"=>"Y","TAA"=>"X","TAG"=>"X",
			"TGT"=>"C","TGC"=>"C","TGA"=>"X","TGG"=>"W","CTT"=>"L","CTC"=>"L",
			"CTA"=>"L","CTG"=>"L","CCT"=>"P","CCC"=>"P","CCA"=>"P","CCG"=>"P",
			"CAT"=>"H","CAC"=>"H","CAA"=>"Q","CAG"=>"Q","CGT"=>"R","CGC"=>"R",
			"CGA"=>"R","CGG"=>"R","ATT"=>"I","ATC"=>"I","ATA"=>"I","ATG"=>"M",
			"ACT"=>"T","ACC"=>"T","ACA"=>"T","ACG"=>"T","AAT"=>"N","AAC"=>"N",
			"AAA"=>"K","AAG"=>"K","AGT"=>"S","AGC"=>"S","AGA"=>"R","AGG"=>"R",
			"GTT"=>"V","GTC"=>"V","GTA"=>"V","GTG"=>"V","GCT"=>"A","GCC"=>"A",
			"GCA"=>"A","GCG"=>"A","GAT"=>"D","GAC"=>"D","GAA"=>"E","GAG"=>"E",
			"GGT"=>"G","GGC"=>"G","GGA"=>"G","GGG"=>"G");

$/=">";
my %bad;
while (<I>) {
	chomp;
	if ($_ ne '') {
		@info=split(/\n/,$_,2);
		$name=(split(/\s+/,$info[0]))[0];
		$info[1]=~s/\s+//g;
		$info[1]=uc($info[1]);
		$num=length($info[1]);
		for ($i=0;$i<$num ;$i=$i+3) {
			$cod=substr($info[1],$i,3);
			if(exists $matrix{$cod}){$pro=$matrix{$cod};$protein.=$pro;}
			else{
				$pro="n";$protein.=$pro;
				$bad{$name}=1;}
			
#			foreach $codon (keys %matrix) {
#				if ($cod eq $codon) {
#					$pro=$matrix{$codon};
#					$protein.=$pro;
#				}
#			}

		}
		$protein=~s/\s+//g;
		print O ">$name\n$protein\n";
		$protein='';
	}
}
foreach my $key (keys %bad) {
	print "$key\n";
}
