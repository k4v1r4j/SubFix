#!/usr/bin/perl
use feature "say";
open $SRT, "guru.srt";
%start_diag;
%start_diff;
while(<$SRT>) {
    if($_ =~ /-->/) {
	$_;
	($start,$end)=split(/-->/,$_);
#	print $cont[0]," : ",$cont[1];
	$start=convert($start);
	$end=convert($end);
	$start_diff{$start}=($end-$start);
	$dialog=<$SRT>;
#	print $dialog;
	$start_diag{$start}=$dialog;
    }
}
print "Enter start time (hr:min:sec): ";
$u_start=<STDIN>;
print "Enter end time (hr:min:sec): ";
$u_end=<STDIN>;
chomp($u_start);
chomp($u_end);
say $u_start," : ",$u_end;
say "Start --- End";
#while(($key,$value)=each(%start_diag)){
 #  print  $key," : ",$value;
#}
#while(($key,$value)=each(%start_diff)) {
#    print "$key: $start_diff{$key}\n";
#}


sub convert() {
    $time=shift;
    ($hr,$min,$sec)=split(':',$time);
    ($sec,$mil_sec)=split(',',$sec);
    $sec=($hr*3600)+($min*60) + $sec;
    $mil_sec+=$sec*1000;
    return $mil_sec;
}

sub revert() {
    $time=shift;
    $sec=$time/1000;
    $mil_sec=$time%1000;
    $min=$sec/60;
    $sec=$sec%60;
    $hr=$min/60;
    $min=$min%60;
    return "$hr:$min:$sec,$mil_sec";
}
