use strict;
use warnings;
use Test::More;
use Try::Tiny;
use t::Util;


subtest 'single plugin' => sub {
    my $t0 = 'foobar';
    is markdown_($t0), "<p>foobar</p>\n";

    subtest 'pre' => sub {
        my $mdp = new_object(
            plugins => [qw/ Prepend /],
        );
        is $mdp->markdown($t0), markdown_("foobar\n" . $t0);
    };

    subtest 'post' => sub {
        my $mdp = new_object(
            plugins => [qw/ Append /],
        );
        is $mdp->markdown($t0), "<p>foobar</p>\n\nfoobar";
    };

    subtest 'pre+post' => sub {
        my $mdp = new_object(
            plugins => [qw/ AppendPrepend /],
        );
        is $mdp->markdown($t0), ( markdown_("foobar\nfoobar") . "\nfoobar" );
    };
};


subtest 'multi plugins' => sub {
    my $t0 = 'foobar';
    is markdown_($t0), "<p>foobar</p>\n";

    my $mdp = new_object(
        plugins => [qw/ Append Prepend /],
    );
    is $mdp->markdown($t0), ( markdown_("foobar\n" . $t0) . "\nfoobar" );
};


done_testing;
