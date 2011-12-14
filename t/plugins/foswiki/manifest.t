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

my $manifest =
  $tzil->slurp_file('build/lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST');

my $expected = <<'HERE';
lib/Foswiki/Plugins/InterwikiPlugin.pm 416
data/System/InterwikiPlugin.txt 416
data/System/InterWikis.txt 416
lib/Foswiki/Plugins/InterwikiPlugin/MANIFEST 420
HERE

is( $manifest, $expected, 'manifest is correct' );

done_testing;
