#!/usr/bin/perl -w
use strict;

#function: 整合paralog，将所有paralog整合到同一个family中
#updata 2006-12-23,修正了用匹配时的错误，要用eq语句，匹配会认为1和11是一样的
open IN,"$ARGV[0]" ||die "cannot open $ARGV[0]";
open OUT, ">$ARGV[1]"||die '!';

#NM_001031873	NM_001031874	NM_001031875	NM_001031876
my %hash;

while (<IN>) {
	chomp;
	$hash{$_}=$_;#读入数据，赋值
}
close IN;

#1，2	2
#1，3	2
#1，4	2
my $process;
open IN,"$ARGV[0]" ||die "cannot open $ARGV[0]";

while (my $line=<IN>) {
	chomp $line;
	my @infor=split /\s+/,$line;
$process++;
print "$process\n";

foreach my $key (keys %hash){ #和每一行循环一遍
		my $tag=0;#设置tag
		#print "$key==========$hash{$key}\n";
		if (!defined $hash{$key}){next;}
		my @element_hash=split /\t/,$hash{$key};
		#print "compar:$line\ncompar:$hash{$key}\n";
		if ($line eq $key) {next;}#自己与自己不比
		else{

			for (my $j=0; $j<@element_hash;$j++){
				for (my $i=0;$i<@infor ;$i++) {
				if ($element_hash[$j] eq $infor[$i]) {
					$tag=1; #有一行包含$line里的任一元素，$tag设为1
					}
				}
			}

			#print "tag:$tag\n";
			if ($tag==1) {
				my $num=0;
				for (my $j=0;$j<@infor ;$j++) {
					for(my $i=0;$i<@element_hash;$i++){
					if ($element_hash[$i] ne $infor[$j]) {
							$hash{$key}=$hash{$key}."\t".$infor[$j];#将不重复的元素放入hash，并删除此行
							delete $hash{$line};#$hash{$line}=A,B,C,D $hash{$key}=A,B,C,E 此时$hash{$key}=A,B,C,D,E 并删除$hash{$infor[0]}
						}
					else{$num++;}#统计元素相等的数目
					}
					

				}
			my $tmp=$hash{$key};  #将hash的key换掉，始终保持key和value相同
			delete $hash{$key};
			$tmp=&clear_hash($tmp);
			$hash{$tmp}=$tmp;
			
						
			#if (((scalar @element_hash)<(scalar @infor) and $num==@element_hash) or ((scalar @element_hash)>(scalar @infor) and $num==@infor) )
		#	{#若其中一行可以匹配另一行的所有元素
		#			delete $hash{$line};#$hash{$infor[0]}=A,B,C $hash{$key}=A,B,C,D 前者包含在后者里面
		#			my $tmp=$hash{$key};
		#			delete 	$hash{$key};
	#				$hash{$tmp}=$tmp;
					
		#	}

			}
		}
	}

}

my %data;
my %new_hash;
my %seen = ( );


#print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n";

foreach my $key (keys %hash){#将hash的值和key都按序排好
#print "key:       $key\n";
#print "value:     $hash{$key}\n";

my @infor=split /\s+/,$hash{$key}; 

my @tmp=sort @infor;

my $temp=join "\t",@tmp;
$new_hash{$temp}=$temp;
$data{$temp}=$temp;
}


#foreach my $key(keys %data){print "$data{$key}\n";}

foreach my $item (keys %data){#去冗余 ,比如一个是1，2，3；一个是1，2，3，4
	my @element_item=split /\s+/,$data{$item};
	foreach my $key (keys %new_hash) {
		my $tag=0;
		my @infor=split /\s+/,$new_hash{$key};
		if ($data{$item} eq $new_hash{$key}){next;}#自己和自己不比
		else
		{
			for (my $j=0;$j<@element_item;$j++){
			for(my $i=0 ;$i<@infor;$i++){
				if($element_item[$j] eq $infor[$i]){$tag++;}
			}

			}
		}
		if((scalar @element_item)< (scalar @infor) and $tag==@element_item){delete $new_hash{$item};}
		elsif((scalar @element_item)> (scalar @infor) and $tag==@infor){delete $new_hash{$key};}
	
}
}

foreach my $key(keys %new_hash)
{	my @infor=split /\s+/,$new_hash{$key};
	print OUT "$new_hash{$key}\n";
}

sub clear_hash
{
	my ($tmp)=@_;
	
	my %seen = ( );
	my @middle=split /\t/,$tmp;
	my @uniq = grep { ! $seen{$_} ++ } @middle;
	my $result=join "\t",@uniq;
	return $result;
	
}
exit;
