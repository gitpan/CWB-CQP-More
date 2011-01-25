#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'CWB::CQP::More' )           || print "Bail out!";
    use_ok( 'CWB::CQP::More::Iterator' ) || print "Bail out!";
}

diag( "Testing CWB::CQP::More $CWB::CQP::More::VERSION, Perl $], $^X" );
