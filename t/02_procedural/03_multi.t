use strict;
use warnings;
use Test::More;
use Text::Markdown::Pluggable qw/markdown/;
use t::Util;


subtest 'ordering "pre"' => sub {
    my $t0 = << '...';
[foobar](http://www.cpan.org/ "cpan")
...
    is markdown($t0), qq{<p><a href="http://www.cpan.org/" title="cpan">foobar</a></p>\n};
    is markdown($t0, [qw/P1 P2/]), qq{<p><a href="http://www.perl.org/" title="perl">foobar</a></p>\n};
    is markdown($t0, [qw/P2 P1/]), qq{<p><a href="http://www.plackperl.org/" title="plackperl">foobar</a></p>\n};
};


subtest 'ordering of "post"' => sub {
    my $t0 = << '...';
foobar
...
    is markdown($t0), "<p>foobar</p>\n";
    is markdown($t0, [qw/P3 P4/]), "<p>foobar</p>\nhogefuga";
    is markdown($t0, [qw/P4 P3/]), "<p>foobar</p>\nfugahoge";
};


done_testing;
