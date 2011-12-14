use strict;
use warnings;

package Dist::Zilla::Plugin::Foswiki::Manifest;

# ABSTRACT: Build a Foswiki MANIFEST

use Moose;
use Moose::Autobox;
with 'Dist::Zilla::Role::FileGatherer';
extends 'Dist::Zilla::Plugin::Manifest';

use namespace::autoclean;

use Dist::Zilla::File::FromCode;

=head1 DESCRIPTION

If included, this plugin will produce a F<MANIFEST> file for the distribution,
listing all of the files it contains.  For obvious reasons, it should be
included as close to last as possible.

TODO: File description

=cut

sub gather_files {
    my ( $self, $arg ) = @_;

    my $zilla = $self->zilla;

    my $manifest = $zilla->main_module->name;
    $manifest =~ s/\.pm$/\/MANIFEST/;

    my $file = Dist::Zilla::File::FromCode->new(
        {
            name => $manifest,
            code => sub {
                $zilla->files->map(
                    sub {
                        Dist::Zilla::Plugin::Manifest::__fix_filename(
                            $_->name )
                          . ' '
                          . $_->mode;
                    }
                  )->join("\n")
                  . "\n",
                  ;
            },
        }
    );

    $self->add_file($file);
}

__PACKAGE__->meta->make_immutable;
1;
