#! /usr/bin/perl
#
# check_prime.pl
# print 1 if input is prime; else print 0


# print "Enter a number\n";

my $n=<>;
my $d=0;

if($n<=1) { print "0\n"; exit };

if($n==2) {
   
    print "1\n";

} else {

    for(my $c=2;$c<=$n-1;$c++) {

	if($n%$c==0) {

	    $d=1;
	    break;

	}

    }

    if($d==1) {

	print "0\n";

    } else {

	print "1\n";

    }

}

