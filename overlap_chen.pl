open(T,"$ARGV[0]");
while(<T>) {
($name,$chromosome,$start,$end,$strand)=split;
$chro{$name}=$chromosome;
$st{$name}=$start;
$ed{$name}=$end;

push(@ID,$name);



}

open(T2,"$ARGV[1]");
while(<T2>) {
@temp=split;
  for($i=0;$i<@ID;$i++)  {
    if ($temp[1] ne $chro{$ID[$i]})  {
    
     next;
    }elsif ($temp[2] >$ed{$ID[$i]}  ||  $temp[3] <$st{$ID[$i]}) {

     next;
    
    }else {

    print "$temp[0]\t$ID[$i]\t$chro{$ID[$i]}\t$st{$ID[$i]}\t$ed{$ID[$i]}\n"
    
    }




  }



}