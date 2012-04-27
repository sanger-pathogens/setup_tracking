#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Path qw(rmtree);

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('SetupTracking::Directories');
}

ok my $directories = SetupTracking::Directories->new(
  pipeline_base_directory => 't/data/pipeline',
  config_base_directory   => 't/data/conf',
  database_name           => 'pathogen_abc_track',
  log_base_directory      => 't/data/log',
  )->create_directories, 'create directories';

ok (-d "t/data/pipeline/pathogen_abc_track/seq-pipelines");
ok (-d "t/data/conf/pathogen_abc_track/mapping");
ok (-d "t/data/log/pathogen_abc_track");

ok $directories->destroy_directories();
ok (! -d "t/data/pipeline/pathogen_abc_track/seq-pipelines");
ok (! -d "t/data/conf/pathogen_abc_track/mapping");
ok (! -d "t/data/log/pathogen_abc_track");


done_testing();