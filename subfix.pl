#!/usr/bin/perl
use feature "say";
open $SRT,"<","guru.srt";
%start_diag;
%start_diff;
%start_cum;
%start_new;
while(<$SRT>) {
    print "fuck you\n";
    if($_ =~ /-->/) {
	$_;
	($start,$end)=split(/-->/,$_);
#	print $cont[0]," : ",$cont[1];
	$start=convert($start);
	$end=convert($end);
	$start_diff{$start}=($end-$start);
	while($dialog=<$SRT>){
#	print $dialog;
	    if($dialog eq "\n") {
		last;
	    }
	    $start_diag{$start}.=$dialog;
	}

    }
}
print "Hello\n";
@keys=sort{$a<=>$b}keys(%start_diag);
for($i=0;$i<@keys-1;$i++) {
    $start_cum{$keys[$i]}=$keys[$i+1]-$keys[$i];
}
$start_cum{$keys[$i]}=0;
print "Enter start time (hr:min:sec): ";
$u_start=<STDIN>;
print "Enter end time (hr:min:sec): ";
$u_end=<STDIN>;
chomp($u_start);
chomp($u_end);
$u_start=convert($u_start);
$u_end=convert($u_end);


# magic hash

for($i=0;$keys[$i]!=$u_start;$i++) {
    $start_magic{$keys[$i]}=$keys[$i];
}
while($keys[$i]!=$u_end) {
    $i++;
}
$i++;

for($j=$u_start;$i<@keys;$i++) {
    $start_magic{$keys[$i]}=$j;
    $j+=$start_cum{$keys[$i]};
}
$count=1;
for $key(sort{$a<=>$b}keys(%start_magic)) {
    print $count++,"\n";
    print revert($start_magic{$key})," --> ",revert($start_magic{$key}+$start_diff{$key}),"\n";
    print $start_diag{$key},"\n";
}
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
    $sec=int($time/1000);
    $mil_sec=$time%1000;
    $min=int($sec/60);
    $sec=$sec%60;
    $hr=int($min/60);
    $min=$min%60;
    $hr="0$hr" if $hr<10;
    $min="0$min" if $min<10;
    $sec="0$sec" if $sec<10;
    if($mil<100) {
	if($mil<10) {
	    $mil="00$mil"
	}
	$mil="0$mil";
    }
    return "$hr:$min:$sec,$mil_sec";
}
