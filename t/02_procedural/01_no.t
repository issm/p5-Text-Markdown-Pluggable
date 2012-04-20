use strict;
use warnings;
use Test::More;
use Text::Markdown::Pluggable qw/markdown/;
use t::Util;


my $text = << '...';
foo

* bar
    * baz

1. ol
2. ol

paragraph

3. ol
4. ol

*****
...

subtest 'no option' => sub {
    is markdown($text), markdown_($text);
};

subtest 'with option(s)' => sub {
    subtest 'same option(s)' => sub {
        my %opts = (
            empty_element_suffix => '>',
            tab_width => 8,
        );
        is markdown($text, \%opts), markdown_($text, \%opts);
    };

    subtest 'different option(s)' => sub {
        my ($html1, $html2);

        # tab_width
        $html1 = markdown($text, {
            tab_width => 2,
        });
        $html2 = markdown_($text, {
            tab_width => 8,
        });
        isnt $html1, $html2;

        # empty_element_suffix
        $html1 = markdown($text, {
            empty_element_suffix => '>',
        });
        $html2 = markdown_($text, {
            empty_eleemnt_suffix => '/>',
        });
        isnt $html1, $html2;

        # trust_list_start_value
        $html1 = markdown($text, {
            trust_list_start_value => 1,
        });
        $html2 = markdown_($text, {
            trust_list_start_value => 0,
        });
        isnt $html1, $html2;
    };
};

done_testing;
