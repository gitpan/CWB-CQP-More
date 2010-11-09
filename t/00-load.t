#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CWB::CQP::More' ) || print "Bail out!
";
}

diag( "Testing CWB::CQP::More $CWB::CQP::More::VERSION, Perl $], $^X" );
