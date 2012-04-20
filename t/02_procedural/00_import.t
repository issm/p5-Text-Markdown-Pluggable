use strict;
use warnings;
use Test::More;
use Try::Tiny;
use Text::Markdown::Pluggable qw/
    import
    new
    load_plugins
    load_plugin
    markdown
/;
use t::Util;


subtest 'can\'t call' => sub {
    subtest 'import' => sub {
        try {
            import();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::import/;
        };
    };

    subtest 'new' => sub {
        try {
            new();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::new/;
        };
    };

    subtest 'load_plugins' => sub {
        try {
            load_plugins();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::load_plugins/;
        };
    };

    subtest 'load_plugin' => sub {
        try {
            load_plugin();
            fail 'Shoud have error';
        } catch {
            my $msg = shift;
            like $msg, qr/Undefined subroutine \&main::load_plugin/;
        };
    };
};


subtest 'can call' => sub {
    subtest 'markdown' => sub {
        try {
            markdown();
            ok 'Can call subroutine 6main::markdown';
        } catch {
            my $msg = shift;
            fail 'Shoud succeed: ' . $msg;
        };
    };
};


done_testing;
