#!/usr/bin/perl -w
use strict;
open HOMO, "$ARGV[0]"||die "!";
open GENE,"$ARGV[1]"||die "!";
#open TMP, ">homo.tmp"||die "!";
open OUT, ">$ARGV[2]"||die '!';

#3	9606	34	ACADM	4557231	NP_000007.1
#3	9615	490207	LOC490207	73960161	XP_547328.2
#3	10090	11364	Acadm	6680618	NP_031408.1
#3	10116	24158	Acadm	8392833	NP_058682.1
#id	specis	geneid	name	protein_gi	protein_acc

my $human=9606;
my $macaca=9544;
my $mouse=10090;
my $rat=10116;
my $fly=7227;
my $chimp=9598;
my $sim=7240;
my $yak=7245;
my $ere=7220;
my $mel=7227;
my $fish=7955;
my $cow=9913;
#my %hash_ortholog;
my %hash_mouse;
my %hash_rat;
my %hash_human;
my %hash_chimp;
my %hash_mel;
my %hash_sim;
my %hash_yak;
my %hash_ere;
my %hash_macaca;
my %hash_fish;
my %hash_cow;

while (my $line=<HOMO>) {
	chomp $line;
	my @infor=split /\t/, $line;
	my $hg_id=$infor[0];
	my $kind=$infor[1];
if ($kind eq $human) {$hash_human{$infor[0]}=$infor[2];}
elsif ($kind eq $mouse){$hash_mouse{$infor[0]}=$infor[2];}
elsif ($kind eq $rat){$hash_rat{$infor[0]}=$infor[2];}
elsif($kind eq $chimp){$hash_chimp{$infor[0]}=$infor[2];}
elsif($kind eq $sim){$hash_sim{$infor[0]}=$infor[2];}
elsif($kind eq $yak){$hash_yak{$infor[0]}=$infor[2];}
elsif($kind eq $ere){$hash_ere{$infor[0]}=$infor[2];}
elsif($kind eq $mel){$hash_mel{$infor[0]}=$infor[2];}
elsif($kind eq $fish){$hash_fish{$infor[0]}=$infor[2];}
elsif($kind eq $cow){$hash_cow{$infor[0]}=$infor[2];}
elsif ($kind eq $macaca){print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";$hash_macaca{$infor[0]}=$infor[2];}
}
close HOMO;

my %hash_gene;
while (my $line=<GENE>) {
chomp $line;
my @infor=split /\t/, $line;
$hash_gene{$infor[1]}=(split /\./,$infor[3])[0];
}
close GENE;

my $count;

foreach my $key (keys %hash_human) {
	#if(exists $hash_gene{$hash_human{$key}} ){
		if(!exists $hash_cow{$key}){next;}
		if(!exists $hash_gene{$hash_cow{$key}} || !exists $hash_gene{$hash_human{$key}}){next;} 
		#if($hash_gene{$hash_human{$key}}=~/^NM/ && $hash_gene{$hash_mouse{$key}}=~/^NM/){
			$count++;
			print OUT "$key\t$hash_gene{$hash_human{$key}}\t$hash_gene{$hash_cow{$key}}\n";
			#}
		#elsif ($hash_gene{$hash_human{$key}}=~/^XM/){}
		
	#}
}


print $count."\n";


#39947	3048088	PROVISIONAL	NM_191635.1	34910353	NP_916524.1	34910354	NT_079927.2	50953503	3727803	3730884	-
#ŒÔ÷÷	gene_id				RNA acc		RNA gi		protein acc	protein gi	
