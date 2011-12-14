# Just testing that GatherDir gets all the files we want
# and does not include test
use strict;
use warnings;
use Test::More 0.88;

use Test::DZil;

my $tzil = Builder->from_config(
    { dist_root => 'corpus/dist/InterwikiPlugin' },
    {
        add_files => {
            'source/dist.ini' => simple_ini(
                [
                    GatherDir => {
                        exclude_match    => 'test',
                        exclude_filename => [ 'build.pl', 'dist.ini' ],
                    }
                ],
            ),
        },
    },
);

$tzil->build;

my @files = map { ; $_->name } @{ $tzil->files };

is_filelist(
    [@files],
    [
        qw(
          lib/Foswiki/Plugins/InterwikiPlugin.pm
          lib/Foswiki/Plugins/InterwikiPlugin/DEPENDENCIES lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST
          data/System/InterwikiPlugin.txt data/System/InterWikis.txt
          )
    ],
    "GatherDir gathers all files in the source dir",
);

# NewInterwikiPlugin
$tzil = Builder->from_config(
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

@files = map { ; $_->name } @{ $tzil->files };

is_filelist(
    [@files],
    [
        qw(
          lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST
          lib/Foswiki/Plugins/InterwikiPlugin.pm
          data/System/InterwikiPlugin.txt data/System/InterWikis.txt
          )
    ],
    "GatherDir gathers all files in the source dir",
);

my $manifest =
  $tzil->slurp_file('build/lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST');
my %in_manifest = map { ; chomp; $_ => 1 } grep { length } split / \d\d\d\n/,
  $manifest;

my $count = grep { $in_manifest{$_} } @files;
ok( $count == @files,             "all files found were in manifest" );
ok( keys(%in_manifest) == @files, "all files in manifest were on disk" );

done_testing;

