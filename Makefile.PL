use ExtUtils::MakeMaker;

sub MY::test_via_harness {
    "\tprove --rc=.proverc t\n";
}

sub MY::top_targets {
    << "    ...";
all ::
\t
pure_all ::
\t
subdirs ::
\t
config ::
\t
    ...
}

WriteMakefile(
    NAME          => 'Text::Markdown::Pluggable',
    AUTHOR        => 'issm <issmxx@gmail.com>',
    VERSION_FROM  => 'lib/Text/Markdown/Pluggable.pm',
    PREREQ_PM     => {
        'parent'            => '0.224',
        'Text::Markdown'    => '1.000031',
        'Class::Load'       => '0.13',
        'Test::Differences' => '0.61',  # in test
        'Try::Tiny'         => '0.11',  # in test
    },
    MIN_PERL_VERSION => '5.008001',
    test => {
        TESTS => 't/*.t t/*/*.t',
    },
);
