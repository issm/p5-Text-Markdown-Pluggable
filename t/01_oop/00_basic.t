use strict;
use warnings;
use Test::More;
use Text::Markdown::Pluggable ();
use Text::Markdown ();
use t::Util;

subtest 'no parameter' => sub {
    my $mdp = new_object();
    isa_ok $mdp, 'Text::Markdown::Pluggable';
    isa_ok $mdp->{plugins}, 'ARRAY';
    isa_ok $mdp->{__modules}, 'ARRAY';
    ok $mdp->can('markdown'), 'can call method "markdown"';
    ok $mdp->can('urls'), 'can call method "urls"';
};

subtest 'with parameter(s)' => sub {
    my $text = << '...';
foo

bar **baz**

* hoge
* fuga
    * piyo-1
    * piyo-2

1. ol
2. ol

paragraph

3. ol
4. ol


*****

[linktext](/url "title")
...

    subtest 'same parameter(s)' => sub {
        my %param = (
            empty_element_suffix => '>',
            tab_width            => 4,
        );
        my $mdp = new_object(%param);
        my $md  = Text::Markdown->new(%param);
        is $mdp->markdown($text), $md->markdown($text);
    };

    subtest 'different parameter(s)' => sub {
        my ($mdp, $md);

        # tab_width
        $mdp = new_object(
            tab_width => 4,
        );
        $md = Text::Markdown->new(
            tab_width => 2,
        );
        isnt $mdp->markdown($text), $md->markdown($text);

        # empty_element_suffix
        $mdp = new_object(
            empty_element_suffix => '>',
        );
        $md = Text::Markdown->new(
            empty_element_suffix => '/>',
        );
        isnt $mdp->markdown($text), $md->markdown($text);

        # trust_list_start_value
        $mdp = new_object(
            trust_list_start_value => 1,
        );
        $md = Text::Markdown->new(
            trust_list_start_value => 0,
        );
        isnt $mdp->markdown($text), $md->markdown($text);
    };
};

done_testing;
