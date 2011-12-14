use strict;
use warnings;
use Test::More 0.88;

use Test::DZil;

my $tzil = Builder->from_config(
    { dist_root => 'corpus/dist/NewInterwikiPlugin' },
    {
        add_files => {
            'source/dist.ini' => simple_ini(
                [
                    GatherDir => {
                        exclude_match    => 'test',
                        exclude_filename => [ 'build.pl', 'dist.ini' ],
                    }
                ],

                'Foswiki::Manifest',
            ),
        },
    },
);

$tzil->build;

my @files = map { ; $_->name } @{ $tzil->files };

my $manifest =
  $tzil->slurp_file('build/lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST');

my %in_manifest;
for my $line ( split /\n/, $manifest ) {
    $line =~ /^(.*) (\d\d\d) ?(.*)/;
    my $path = $1;
    my $mode = $2;
    my $desc = $3;

    ok( $path, 'each manifest line has a path' );
    ok( $mode, 'each manifest line has a mode' );

    $in_manifest{$path} = $mode;
}

my $count = grep { $in_manifest{$_} } @files;
ok( $count == @files,             "all files found were in manifest" );
ok( keys(%in_manifest) == @files, "all files in manifest were on disk" );

done_testing;
