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

                #'Manifest', # might use Foswiki::AutoManifest here
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

                #'Manifest', # might use Foswiki::AutoManifest here
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
          lib/Foswiki/Plugins/InterwikiPlugin.pm
          data/System/InterwikiPlugin.txt data/System/InterWikis.txt
          )
    ],
    "GatherDir gathers all files in the source dir",
);

done_testing;

