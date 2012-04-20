package t::Util;
use strict;
use warnings;
use utf8;
use Text::Markdown ();
use Text::Markdown::Pluggable;

sub import {
    my @subs = qw/
        new_object
        markdown_
    /;

    my $caller = caller;

    for my $f (@subs) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}

sub new_object {
    return Text::Markdown::Pluggable->new(@_);
}

sub markdown_ {
    return Text::Markdown::markdown(@_);
}

1;
