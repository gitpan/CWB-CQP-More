use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CWB::CQP::More',
    AUTHOR              => q{Alberto Simoes <ambs@cpan.org>},
    VERSION_FROM        => 'lib/CWB/CQP/More.pm',
    ABSTRACT_FROM       => 'lib/CWB/CQP/More.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
                  'CWB'        => 3,
                  'Test::More' => 0,
                  'Try::Tiny'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CWB-CQP-More-*' },
);
