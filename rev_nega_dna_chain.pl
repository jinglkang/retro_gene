#!/usr/bin/perl
open(fil,"$ARGV[0]");
while(<fil>){
chomp;
if(/>/){
split;
$names=$_[0];
($name)=split(/__/,$names);
if($_[-1] eq '+'){$flag{$name}=0;}else{
$flag{$name}=1;}
   }else{
$seq{$name}.=$_;}
}
for (keys %seq){
if($flag{$_}){
$seq{$_}=~tr/ATCGatcg/TAGCtagc/;
$seq{$_}=reverse($seq{$_});}
print "$_\n";
print "$seq{$_}\n";}