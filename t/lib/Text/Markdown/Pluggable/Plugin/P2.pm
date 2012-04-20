package Text::Markdown::Pluggable::Plugin::P2;
use strict;

sub pre {
    my ($o, $text) = @_;
    $text =~ s/cpan/plackperl/g;
    return $text;
}

1;
