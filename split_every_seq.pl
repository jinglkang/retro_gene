#!usr/bin/perl -w
open(I,"$ARGV[0]");

while(<I>)
{chomp;
 if(/^>/)
{# s/>//;
  @te=split(/\__/,);
#$te[0]= s/\s//g;
$te[0]=~ s/>//;
  $na=$te[0];}
else
 { $s{$na}.=$_;
}} 
while(($key,$value)=each %s){
    open(T,">$key.fa");
    print T ">$key\n$value";
    close T;
}

