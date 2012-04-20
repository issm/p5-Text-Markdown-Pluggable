use strict;
use warnings;
use Test::More;
use Try::Tiny;
use t::Util;


subtest 'good' => sub {
    my $mdp = new_object();

    is $mdp->load_plugins(qw/
        P1
        P2
        +My::Other::Plugin::Foobar
    /), 3;

    is_deeply $mdp->{__modules}, [qw/
        Text::Markdown::Pluggable::Plugin::P1
        Text::Markdown::Pluggable::Plugin::P2
        My::Other::Plugin::Foobar
    /];

    is $mdp->load_plugins(qw/
        P3
        P4
    /), 2;

    is_deeply $mdp->{__modules}, [qw/
        Text::Markdown::Pluggable::Plugin::P1
        Text::Markdown::Pluggable::Plugin::P2
        My::Other::Plugin::Foobar
        Text::Markdown::Pluggable::Plugin::P3
        Text::Markdown::Pluggable::Plugin::P4
    /];
};


subtest 'bad' => sub {
    my $mdp = new_object();

    try {
        $mdp->load_plugins(qw/
            P1
            P2
            PluginDoesNotExist
        /);
        fail 'Shoud have error';
    } catch {
        my $msg = shift;
        like $msg, qr{Can't locate Text/Markdown/Pluggable/Plugin/PluginDoesNotExist.pm};
    };
};


done_testing;
