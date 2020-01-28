#!usr/bin/perl -w
open(I,"$ARGV[0]")||die"!!!!";
open(L,"$ARGV[1]");
open(O,">$ARGV[2]");
@ii=<I>;
#while(<I>)
#{@temp=split;
# $le{$temp[0]}=$temp[1];
#}

while(<L>)
{ @te=split;
   for $yu(@ii)
  { ($mi[0],$mi[1])=split(/\s+/,$yu,2) ;
    $le{$mi[0]}=$mi[1];
    if($te[0] eq $mi[0])
      {  print O "$te[0]\t$le{$te[0]}";}
}

}
