package Text::Markdown::Pluggable::Plugin::Prepend;
use strict;

sub pre {
    my ($o, $text) = @_;
    return "foobar\n" . $text;
}

1;
