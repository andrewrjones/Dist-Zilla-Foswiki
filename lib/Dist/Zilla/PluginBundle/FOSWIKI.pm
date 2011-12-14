use strict;
use warnings;

package Dist::Zilla::PluginBundle::FOSWIKI;

# ABSTRACT: L<Dist::Zilla> plugins for Foswiki development

use Moose;
use Moose::Autobox;
use Dist::Zilla 2.100922;
with 'Dist::Zilla::Role::PluginBundle::Easy';

=for stopwords Prereqs CPAN
=head1 DESCRIPTION

This is the plugin bundle for Foswiki development. It is equivalent to:

  [GatherDir]
  
  [Foswiki::Manifest]

=cut

# Alphabetical
use Dist::Zilla::Plugin::Foswiki::Manifest;
use Dist::Zilla::Plugin::GatherDir;

=for Pod::Coverage configure
=cut

sub configure {
    my ($self) = @_;

    $self->add_plugins(
        [
            GatherDir => {
                exclude_match    => 'test',
                exclude_filename => [ 'build.pl', 'dist.ini' ],
            }
        ],
    );

    $self->add_plugins('Foswiki::Manifest');
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
