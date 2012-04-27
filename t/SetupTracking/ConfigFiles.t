#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Compare;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use SetupTracking::Directories;
    use_ok('SetupTracking::ConfigFiles');
}

my $directories = SetupTracking::Directories->new(
    pipeline_base_directory => 't/data/pipeline',
    config_base_directory   => 't/data/conf',
    database_name           => 'pathogen_abc_track',
    log_base_directory      => 't/data/log')
  ->create_directories;
  
ok (my $config_files_obj = SetupTracking::ConfigFiles->new(
    directories_obj => $directories,
  )->create_config_files(), "initialise config files object and create the files");
  
ok (-e 't/data/conf/pathogen_abc_track_pipeline.conf', 'toplevel pipeline config file created');
ok (-e 't/data/conf/pathogen_abc_track/store_lanes_to_nfs.conf', 'store lanes config file created');
ok (-e 't/data/conf/pathogen_abc_track/qc/qc_lanes.conf', 'qc lanes config file created');
ok (-e 't/data/conf/pathogen_abc_track/mapping/mapping_lanes.conf', 'mapping lanes config file created');

is 0, compare('t/data/conf/pathogen_abc_track_pipeline.conf',              "t/data/expected_pathogen_abc_track_pipeline.conf"), 'top level file contains expected content';
is 0, compare('t/data/conf/pathogen_abc_track/store_lanes_to_nfs.conf',    "t/data/expected_store_lanes_to_nfs.conf"), 'stored lanes file contains expected content';
is 0, compare('t/data/conf/pathogen_abc_track/qc/qc_lanes.conf',           "t/data/expected_qc_lanes.conf"), 'qc lanes file contains expected content';
is 0, compare('t/data/conf/pathogen_abc_track/mapping/mapping_lanes.conf', "t/data/expected_mapping_lanes.conf"), 'mapping lanes file contains expected content';

$config_files_obj->destroy_config_files();
ok (! -e 't/data/conf/pathogen_abc_track_pipeline.conf', 'toplevel pipeline config file deleted');
ok (! -e 't/data/conf/pathogen_abc_track/store_lanes_to_nfs.conf', 'store lanes config file deleted');
ok (! -e 't/data/conf/pathogen_abc_track/qc/qc_lanes.conf', 'qc lanes config file deleted');
ok (! -e 't/data/conf/pathogen_abc_track/mapping/mapping_lanes.conf', 'mapping lanes config file deleted');

$directories->destroy_directories();
done_testing();
