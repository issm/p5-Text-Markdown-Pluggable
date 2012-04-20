use strict;
use warnings;
use Test::More;
use Text::Markdown::Pluggable qw/markdown/;
use t::Util;

my $t0 = << '...';
foo

* bar
...
my $t1 = "foobar\n" . $t0;

subtest 'no option' => sub {
    is markdown($t0, [qw/Prepend/]), markdown_($t1);
    is markdown($t0, [qw/Append/]), markdown_($t0) . "\nfoobar";
    is markdown($t0, [qw/AppendPrepend/]), ( markdown_($t1) . "\nfoobar" );
    is markdown($t0, [qw/+My::Other::Plugin::Foobar/]), ( markdown_($t0) . "hogepiyo" );
};

subtest 'with option' => sub {
    my $t = '*****';
    is markdown_($t), "<hr />\n";

    is markdown($t, [qw/Prepend/], { empty_element_suffix => '>' }), "<p>foobar</p>\n\n<hr>\n";
    is markdown($t, { empty_element_suffix => '>' }, [qw/Prepend/]), "<p>foobar</p>\n\n<hr>\n";

    is markdown($t, [qw/Append/], { empty_element_suffix => '>' }), "<hr>\n\nfoobar";
    is markdown($t, { empty_element_suffix => '>' }, [qw/Append/]), "<hr>\n\nfoobar";
};

done_testing;
