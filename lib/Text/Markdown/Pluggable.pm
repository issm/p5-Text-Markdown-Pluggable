package Text::Markdown::Pluggable;
use 5.008001;
use strict;
use warnings;
use parent 'Text::Markdown';
use Text::Markdown ();
use Class::Load ();

our $VERSION = '0.02';

sub import {
    my ($class, @subs) = @_;
    my $caller = caller;

    my $re_subs_can_import = qr/^(?:markdown)$/;
    my @subs_import = grep /$re_subs_can_import/, @subs;

    for my $f (@subs_import) {
        no strict 'refs';
        *{"$caller\::$f"} = \&$f;
    }
}

sub new {
    my ($class, %params) = @_;
    my %params_super = %params;
    delete $params_super{plugins};
    my $self = bless Text::Markdown->new(%params_super), $class;

    # additional properties;
    $self->{plugins}   = [];
    $self->{__modules} = [];

    my $plugins = $params{plugins} || $params{plugin};
    $plugins ||= [];
    $plugins = [$plugins]  if ref($plugins) eq '';

    $self->load_plugins(@$plugins);

    return $self;
}

sub load_plugins {
    my ($self, @modules) = @_;
    $self->load_plugin($_)  for @modules;
    return +@modules;
}

sub load_plugin {
    my ($self, $module) = @_;
    my $prefix = __PACKAGE__ . '::Plugin::';
    if ( $module =~ /^\+/ ) {
        $module =~ s/^\+//;
    } else {
        $module = $prefix . $module;
    }
    Class::Load::load_class($module)  &&  (push @{$self->{__modules}}, $module);
    return 1;
}

### override of Text::Markdown
sub markdown {
    my ($self, $text, $plugins, $options);
    my $ret = '';

    ### oop
    if ( ref($_[0]) eq __PACKAGE__ ) {
        $self = shift;
        $text = shift;
        ($plugins) = grep ref($_) eq 'ARRAY', @_;
        $self->load_plugins(@$plugins)  if defined $plugins;
    }
    ### procedural
    unless (defined $self) {
        $text = shift;
        ($plugins) = grep ref($_) eq 'ARRAY', @_;
        ($options) = grep ref($_) eq 'HASH', @_;
        $self = __PACKAGE__->new(
            plugins => $plugins,
            %{$options || {}},
        );
    }
    $ret = $text;
    $ret = ''  unless defined $ret;

    my @modules = @{$self->{__modules}};

    ### pre
    for my $m (@modules) {
        my $f = do {
            no strict 'refs';
            *{"$m\::pre"};
        };
        local $@;
        my $t = eval { $f->($self, $ret) };
        next  if $@;
        $ret = $t;
    }

    ### markdown
    $ret = Text::Markdown->new(
        %{$self->{params}},
    )->markdown($ret);

    ### post
    for my $m (@modules) {
        my $f = do {
            no strict 'refs';
            *{"$m\::post"};
        };
        local $@;
        my $t = eval { $f->($self, $ret) };
        next  if $@;
        $ret = $t;
    }

    return $ret;
}

1;
__END__

=head1 NAME

Text::Markdown::Pluggable - plagguable markdown

=head1 SYNOPSIS

  use Text::Markdown::Pluggable qw/markdown/;
  my $html = markdown($text, [qw/Foobar +MyApp::Markdown::Plugin/]);

  use Text::Markdown::Pluggable qw/markdown/;
  my $html = markdown($text, [qw/Foobar +MyApp::Markdown::Plugin/], {
      empty_element_suffix => '>',
      tab_width => 2,
  });

  use Text::Markdown::Pluggable;
  my $m = Text::Markdown->new(
      plugins => [qw/Foobar +MyApp::Markdown::Plugin/],
  );
  my $html = $m->markdown($text);

  use Text::Markdown::Pluggable;
  my $m = Text::Markdown->new(
      plugins => [qw/Foobar +MyApp::Markdown::Plugin/],
      empty_element_suffix => '>',
      tab_width => 2,
  );
  my $html = $m->markdown($text);


=head1 DESCRIPTION

Text::Markdown::Pluggable is a subclass of Text::Markdown and can load plugins that can process before and/or after processing "markdown-ed" text.

=head1 HOW TO CREATE PLUGIN

You can create "plugin module" as follows:

  package Text::Markdown::Pluggable::Plugin::Foobar;

  # before proceccing markdown-ed text
  sub pre {
      my $m    = shift;
      my $text = shift;  # text BEFORE processing
      ...
      return $text;
  }

  # after proceccing markdown-ed text
  sub post {
      my $m    = shift;
      my $text = shift;  # text AFTER processing
      ...
      return $text;
  }

  1;

Subroutine "pre" defines the processing BEFORE processing "markdown-ed" text, and subroutine "post" defines the processing AFTER processing "markdown-ed" text.

You don't need to follow "Text::Markdown::Pluggable::Plugin::*" namespace:

  package MyApp::Markdown::Plugin;

  ...

  1;

These plugins can be loaded in your script, as in SYNOPSYS.

=head1 CONSTRUCTOR

=head2 $m = Text::Markdown::Pluggable->new(%params)

Prameters are available as follows:

=over 4

=item plugins => \@plugins

Plugin module name(s) to load.

=back

Parametes in Text::Markdown->new ("empty_element_suffix", "tab_width" and "truncate-lines") are also available.

=head1 METHODS

=head2 $m->load_plugin($plugin)

Loads plugin.

=head2 $m->load_plugins(@plugins)

Loads plugins.

=head2 $html = $m->markdown($text)

Basically, same as markdown method in Text::Markdown.

If plugins are already loaded, they are processed before and/or after processing $text.

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=head1 SEE ALSO

L<Text::Markdown>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
