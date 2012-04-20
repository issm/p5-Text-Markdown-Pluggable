use strict;
use warnings;
use Test::More;
use Test::Differences;
use Text::Markdown::Pluggable qw/markdown/;
use t::Util;


subtest 'gist' => sub {
    my $markdown = new_object(
        plugins => [qw/ GitHub::Gist /],
    );

    subtest 'simple' => sub {
        eq_or_diff (
            $markdown->markdown( 'gist:123456' ),
            qq{<script src="https://gist.github.com/123456.js"></script>\n},
        );

        eq_or_diff (
            $markdown->markdown( 'gist:123456#file1' ),
            qq{<script src="https://gist.github.com/123456.js?file=file1"></script>\n},
        );
    };
};


done_testing;
