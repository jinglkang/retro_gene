#!/usr/local/bin/perl 
my ($refseq,$est,$est_GC,$refseq_new_pos)=@ARGV; #$refseq是refseq的定位信息，$est是所有est的定位信息，$est_GC是给每一个est附上一个所属的refseq的输出,$refseq_new_pos是更新的refseq位置的输出

open(REF, $refseq) || die "!";
open(EST, $est) || die "!";
open(EST_GC, ">$est_GC") || die "!";
open(REF_NEW, ">$refseq_new_pos") || die "!";
open(NO,">$est.not.found.refseq")||die "!";

my %hash=();
my %hash_start=();
my %hash_end=();
my %hash_name=();
my %hash_ugid=();


my %hash_est_start=();
my %hash_est_end=();
my %hash_est_name=();
my %hash_est_ugid=();


#my %est_tag = ();

#1293	432	3	0	0	1	1	2	6411	+	AL137623	624	0	436	chr9	138429268	92919800	92926646	4	30,132,266,7,	0,30,162,429,	92919800,92921307,92926373,92926639,	Hs.2	2	678
#910	2465	0	91	0	0	0	7	23178	+	NM_003758	2558	0	2556	chr15	100338915	42616557	42642291	8	170,104,55,92,115,162,74,1784,	0,170,274,329,421,536,698,772,	42616557,42616813,42630365,42630920,42634042,42636978,42639738,42640507,	H.2	3	456
#                                                       10                            14                                                                                                                                                                                         22  23   24    
 

#print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
#my %sum1;
#my %sum2;
while(my $line=<REF>) {#将所有ref的信息给hash
	chomp $line;
	my @infor = split /\t/,$line;
	$hash{$infor[10]}=$line;
	my $ugid=$infor[22];
	
	$hash_name{$ugid}=$infor[10];
	$hash_start{$ugid}=$infor[16];
	$hash_end{$ugid}=$infor[17];
	
}

while(my $line=<EST>) {#将所有est的信息给hash
	chomp $line;
	my @infor = split /\t/,$line;
	my $est_start=$infor[16];
	my $est_end=$infor[17];
	my $est_ugid=$infor[22];
	if ($est_start>$hash_end{$est_ugid} or $est_end < $hash_start{$est_ugid}){print NO $line,"\n";next;}#有多个hit的est在这步应该能被去除
	#每个est和他所属的ugid的refseq去比
	else {
	if ($est_start < $hash_start{$est_ugid} ) {$hash_start{$est_ugid} = $est_start;} 
	if ($est_end > $hash_end{$est_ugid} ) {$hash_end{$est_ugid} = $est_end;}         
	}
	if (!exists $hash_name{$est_ugid}) {print NO $line,"\n";print ">>>>>>>>>>>>>>>>>>>>";}
	else{print EST_GC "$line\t$hash_name{$est_ugid}\n";}
}


foreach my $key (keys %hash){
my @infor=split /\t/, $hash{$key};
my $ugid=$infor[22];

if ($hash_start{$ugid}-5000<=0){$hash_start{$ugid}=1;}else {$hash_start{$ugid}=$hash_start{$ugid}-5000;}
if ($hash_end{$ugid}+5000>=$infor[15]){$hash_end{$ugid}=$infor[15]} else {$hash_end{$ugid}=$hash_end{$ugid}+5000}

print REF_NEW "$infor[10]\t$infor[14]\t$infor[9]\t$hash_start{$ugid}\t$hash_end{$ugid}\n";


}



close REF;
close EST;
close EST_GC;
close REF_NEW;
close NO;
exit







#my @ay_sorted_start=();
#my @ay_sorted_end=();
#my @keys_sort_by_start= sort by_chr_and_start keys %hash_est_chr; #得到按chr和start排序的est的key
#foreach $key (@keys_sort_by_start) {
#	push @ay_sorted_start,$hash_est{$key};
#}

#print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";
########################得到每一个refseq最末尾的位置
#foreach my $item (@ay_sorted_start) {
#	chomp $item;
#	my @infor = split /\t/,$item;
#	my $est_start=$infor[16];
#	my $est_end=$infor[17];
#	my $est_ugid=$infor[22];
#	
#	if ($est_start < $hash_start{$est_ugid} ) {$hash_start{$est_ugid} = $est_start;}
#	if ($est_end > $hash_end{$est_ugid} ) {$hash_end{$est_ugid} = $est_end;}
#				
#}
###################
#
#
#
#my @keys_sort_by_end= sort by_chr_and_end keys %hash_est_chr;#得到按chr和end排序的est的key
#
#foreach $key (@keys_sort_by_end) {
#	push @ay_sorted_end, $hash_est{$key};
#}

#print ">>>>>>>>>>>>>>>>>>>>>>>>";
########################得到每一个refseq最起始的位置
#foreach my $item (@ay_sorted_end) {
#	chomp $item;
#	my @infor = split /\t/,$item;
#	#my $name=$infor[10];
#	my $est_start=$infor[16];
#	my $est_end=$infor[17];
#	#my $est_chr=$infor[14];
#	my $est_ugid=$infor[22];
#
#	if ($est_start < $hash_start{$est_ugid} ) {$hash_start{$est_ugid} = $est_start;}
#	if ($est_end > $hash_end{$est_ugid} ) {$hash_end{$est_ugid} = $est_end;}
#
#}
###################
#print "+++++++++++++++++++++++";

############################输出est所属的refseq
#foreach my $item (@ay_sorted_start) {
#	chomp $item;
#	my @infor = split /\t/,$item;
#	my $name=$infor[10];
#	my $est_start=$infor[16];
#	my $est_end=$infor[17];
#	my $est_chr=$infor[14];
#	my $est_ugid=$infor[22];
#
#	if (!exists $hash_name{$est_ugid}) {print NO "$item\n";}
#
#	else{print EST_GC "$item\t$hash_name{$est_ugid}\n";}
#}
#############################
 





# sub by_chr_and_start {
#	$hash_est_chr{$a} cmp $hash_est_chr{$b}
#	or 
#	$hash_est_start{$a} <=> $hash_est_start{$b}  
#    }
#
#  sub by_chr_and_end {
#	$hash_est_chr{$a} cmp $hash_est_chr{$b}
#	or 
#	$hash_est_end{$a} <=> $hash_est_end{$b}  
#    }
