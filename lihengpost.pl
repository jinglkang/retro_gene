($F_in,$F_out_best,$F_out_best_tab) = @ARGV;
#0610007F03      524     1       504     -       chr5    0       10727208        161651071       6       378     1,134;132,155;154,318;317,389;435,480;484,504;      161650935,161651071;161646457,161646480;161645591,161645755;161643035,161643107;161642944,161642990;10727208,10727228; 
#NM_024406       133     62      131     +       chrX_random     1719168 992811  993017  1       50      62,131; 992811,993017;       +50;



#BC058192,1      1980    1       1980    +       NM_023898       371353  91979   94590   2       1636    1,1533;1239,1980;   91979,93526;93832,94590; +1275;+606;
open(I,$F_in);
open(OB,">$F_out_best");
open(OT,">$F_out_best_tab");
open(OC,">$F_out_best\.cutoff");
while(<I>)
{
	@tmp = ();
	$size0 = 0;
	$rough = 0;
	chomp;

	@temp = split(/\s+/,$_);
	$name = $temp[0];
	$length = $temp[1];
	$exact = $temp[10];
	chop($temp[11]);
	@tmp = split(/[\,\;]/,$temp[11]);
	for($i=0;$i<$#tmp;$i+=2)
	{
		$size0 += $tmp[$i+1] - $tmp[$i] + 1;	#$size0是各个片断的总长，含有overlap的
	}
	unshift(@tmp,"1");
	@tmp = &cat(@tmp);
	#print "@tmp\n";
	for($i=0;$i<$#tmp;$i+=2)
	{
		$rough += $tmp[$i+1] - $tmp[$i] + 1;	#去除每个片段overlap的比到的实际长度
	}
	$over = $size0 - $rough;	#overlap的大小
	$exact = $exact - $over;	#去除overlap的实际的精确比到的长度

my @match_len=split /;/,$temp[13];

$match_total=0;
for ($i=0;$i<=@match_len-1 ;$i++) {
	#print ">>>>>>>",$match_len[$i],"\n";
	$match_len[$i]=~s/\+//;
	$match_len[$i]=~s/-//;
	#print $match_len[$i],"\n";
	$match_total+=$match_len[$i];
}



	$cutoff = int($rough/$length*10000)/100;


	$identity = int($exact/$rough*10000)/100;
	$identity_lixin=int($match_total/$size0*10000)/100;
	if ($match_total!=$temp[10]) {$identity=$identity_lixin;}

#print "$match_total\t$identity\t$identity_lixin\n";


	$best = $exact;	#按精确比到的最长的作为最好的
	if(!defined($best{$name}) || $best{$name} < $best)
	{
		$best{$name} = $best;
		$best_result{$name} = $_;
		$best_tab{$name} = "$name\t$rough\t$cutoff\t$identity";
		$best_id{$name}="$name\t$cutoff";
	}
}

foreach $name (keys %best)
{
	print OB "$best_result{$name}\n";
	print OT "$best_tab{$name}\n";
	print OC "$best_id{$name}\n";
}

close(I);
close(OB);
close(OT);
close(OC);

sub cat
		#function:quit redundance
		#input:($para,@array), para is the merge length 
		#output:(@array), 
		#for example (0,1,3,4,7,5,8)->(1,3,4,8) (1,1,3,4,7,5,8)->(1,8)
		{
			my($merge,@input) = @_;
			my $i = 0;
			my @output = ();
			my %hash = ();
			my $each = 0;
			my $begin = "";
			my $end = 0;
			my $Qb = 0; 
			my $Qe = 0; 
			my $temp = 0; 


			for ($i=0;$i<=@input;$i+=2) 
			{
				$Qb = $input[$i];
				$Qe = $input[$i+1];

				if($Qb > $Qe) { $temp = $Qb; $Qb = $Qe; $Qe = $temp; }
				if(defined($hash{$Qb}))	{ if($hash{$Qb} < $Qe) { $hash{$Qb} = $Qe; } }
				else { $hash{$Qb} = $Qe; }
				$Qb = 0; 
			}

			foreach $each (sort {$a <=> $b} keys %hash) 
			{
				if($begin eq "")
				{
					$begin = $each;
					$end = $hash{$each};
				}
				else
				{
					if($hash{$each} > $end) 
					{
						if($each > $end + $merge) 
						{ 
							push(@output,$begin);
							push(@output,$end);
							$begin = $each; 
							$end = $hash{$each};
						}
						else { $end = $hash{$each}; }
					}
				}
			}
			push(@output,$begin);
			push(@output,$end);

			%hash = ();

			return(@output);
		}

exit;
