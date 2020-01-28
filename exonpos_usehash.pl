#!/usr/bin/perl -w

open IN, "$ARGV[0]"||die "!";
#open OUT1, ">$ARGV[1]"||die "!";
#open OUT2, ">$ARGV[2]"||die "!";
my @data=();
while (my $line=<IN>) {
if($line=~/^\w/){push @data,$line;}
}
#将数据放入数组
my $i=0;
my $j;

#BC065205,1       NM_201545       -       37542   37676   135
#BC065205,2       NM_201545       -       37837   37995   159
#BC065205,3       NM_201545       -       38932   39082   151

while ($i<= (scalar @data)-1) {
	
	
	
	my $count=0;
	my $number=0;
	my @ay;
	chomp $data[$i];
	my @infor=split (/\t/,$data[$i]);
	my $Q_name=$infor[0];
	$Q_name=~s/','//;

	my $T_name=$infor[1];
	my $strand=$infor[2];	
	my $T_start=$infor[3]; 	
	my $T_end =$infor[4]; 	
	my $T_size =$infor[5];
	
	$ay[$number]=$data[$i]."\n";
	$number++;
	$count=scalar @ay;

	if ($i==(scalar @data)-1) {

		print ">>>\t$infor[0]\n";  #111111111111111111111
		#print OUT1 "$infor[0]\t$T_name\t$strand\t$T_start\t$T_end\t$T_size\t$count\n";last;
		}
#如果循环到最好一行，输出，并跳出
		
	for ( $j=($i+1);$j<=(scalar @data)-1;$j++) {
		 
		 if ($j==(scalar @data)) {last;}

		chomp $data[$j];
		my @infor_new=split /\t/,$data[$j];
		my $Q_name_new=$infor_new[0];
		$Q_name_new=~s/','//;
		my $T_name_new=$infor_new[1];
		my $strand_new=$infor_new[2];	
		my $T_start_new=$infor_new[3]; 	
		my $T_end_new =$infor_new[4]; 	
		my $T_size_new =$infor_new[5];
		
		
		if (($T_name eq $T_name_new) and (abs($T_start_new-$T_start)<=1 and abs($T_end_new-$T_end)<=1)) {
				$ay[$number]=$data[$j]."\n";$number++; #把相同的exon放入数组ay
				if ($j==(scalar @data)-1) {#如果刚好循环的最后，输出
							$count=(scalar @ay);
							if ($count==1){
						
								
								#print OUT1 "$infor[0]\t$T_name\t$strand\t$T_start\t$T_end\t$T_size\t$count\n";
								print ">>>\t$infor[0]\n"; #2222222222222222
								print @ay; #33333333333333333

								}
							else{

									
									chomp $ay[int($count/2)];
									
									@tmp=split (/\t/,$ay[int($count/2)]);
									#print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$count\n";
						
						print ">>>\t$tmp[0]\n";   #4444444444444444444
						$ay[int($count/2)].="\n";
						print @ay; #555555555555555555555555
								}
						$i=$i+$count;
						last;
					}
				}
		else {
		    $count=(scalar @ay);
					if ($count==1){
							#print OUT1 "$infor[0]\t$T_name\t$strand\t$T_start\t$T_end\t$T_size\t$count\n";
							print ">>>\t$infor[0]\n"; #6666666666
							print @ay;      #77777777777777777
						}
					else {

					
						chomp $ay[int($count/2)];
						@tmp=split (/\t/,$ay[int($count/2)]);
						#print OUT1 "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$count\n";
						
						print ">>>\t$tmp[0]\n";  #888888888888888
						$ay[int($count/2)].="\n";
						print @ay;             #99999999999999999

						}
			$i=$i+$count;
				
		    last;
		}
			
	}
}

close IN;
#close OUT1;
#close OUT2;
exit