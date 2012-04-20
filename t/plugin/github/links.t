use strict;
use warnings;
use Test::More;
use Test::Differences;
use Text::Markdown::Pluggable qw/markdown/;
use t::Util;


subtest 'user, repository' => sub {
    my $markdown = new_object(
        plugins => [qw/ GitHub::Links /],
    );

    subtest 'simple' => sub {
        eq_or_diff (
            $markdown->markdown( 'github:issm' ),
            qq{<p><a href="https://github.com/issm">github:issm</a></p>\n},
        );

        eq_or_diff (
            $markdown->markdown( 'github:issm/p5-Text-Markdown-Pluggable' ),
            qq{<p><a href="https://github.com/issm/p5-Text-Markdown-Pluggable">github:issm/p5-Text-Markdown-Pluggable</a></p>\n},
        );
    };

    subtest 'complicated' => sub {
        eq_or_diff (
            $markdown->markdown( << '...' ),
foo github:issm bar
*hoge* github:nagoyapm __fuga__

foo github:issm/p5-Text-Markdown-Pluggable bar
...
            << '...',
<p>foo <a href="https://github.com/issm">github:issm</a> bar
<em>hoge</em> <a href="https://github.com/nagoyapm">github:nagoyapm</a> <strong>fuga</strong></p>

<p>foo <a href="https://github.com/issm/p5-Text-Markdown-Pluggable">github:issm/p5-Text-Markdown-Pluggable</a> bar</p>
...
        );
    };
};


done_testing;
