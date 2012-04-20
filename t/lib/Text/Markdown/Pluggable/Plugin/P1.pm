package Text::Markdown::Pluggable::Plugin::P1;
use strict;

sub pre {
    my ($o, $text) = @_;
    $text =~ s/cpan/perl/g;
    return $text;
}

1;
