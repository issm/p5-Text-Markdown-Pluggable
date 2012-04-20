use strict;
use warnings;
use Test::More;
use Try::Tiny;
use t::Util;


subtest 'named "Text::Markdown::Pluggable::Plugin::*"' => sub {
    subtest 'good' => sub {
        my $mdp = new_object();
        try {
            is $mdp->load_plugin('P1'), 1;
            is $mdp->load_plugin('P2'), 1;
            is $mdp->{__modules}[0], 'Text::Markdown::Pluggable::Plugin::P1';
            is $mdp->{__modules}[1], 'Text::Markdown::Pluggable::Plugin::P2';
        } catch {
            my $msg = shift;
            fail 'Should succeed: ' . $msg;
        };
    };

    subtest 'bad' => sub {
        my $mdp = new_object();
        try {
            $mdp->load_plugin(qw/ PluginDoesNotExist /);
            fail 'Should have error';
        } catch {
            my $msg = shift;
            like $msg, qr{Can't locate Text/Markdown/Pluggable/Plugin/PluginDoesNotExist\.pm};
        };
    };
};

subtest 'other module' => sub {
    subtest 'good' => sub {
        my $mdp = new_object();
        try {
            is $mdp->load_plugin('+My::Other::Plugin::Foobar'), 1;
            is $mdp->{__modules}[0], 'My::Other::Plugin::Foobar';
        } catch {
            my $msg = shift;
            fail 'Should succeed: ' . $msg;
        };
    };

    subtest 'bad' => sub {
        my $mdp = new_object();
        try {
            $mdp->load_plugin('+My::Other::Plugin::PluginDoesNotExist');
            fail 'Should have error';
        } catch {
            my $msg = shift;
            like $msg, qr{Can't locate My/Other/Plugin/PluginDoesNotExist.pm};
        };
    };
};

subtest 'mixed' => sub {
    subtest 'order 1' => sub {
        my $mdp = new_object();
        $mdp->load_plugin('P1');
        $mdp->load_plugin('+My::Other::Plugin::Foobar');
        is_deeply $mdp->{__modules}, [
            'Text::Markdown::Pluggable::Plugin::P1',
            'My::Other::Plugin::Foobar',
        ];
    };

    subtest 'order 2' => sub {
        my $mdp = new_object();
        $mdp->load_plugin('+My::Other::Plugin::Foobar');
        $mdp->load_plugin('P1');
        is_deeply $mdp->{__modules}, [
            'My::Other::Plugin::Foobar',
            'Text::Markdown::Pluggable::Plugin::P1',
        ];
    };
};


done_testing;
