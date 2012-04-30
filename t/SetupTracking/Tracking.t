#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('SetupTracking::Tracking');
}


ok(my $tracking = SetupTracking::Tracking->new(
  short_name => 'abc123',
  pipeline_base_directory => 't/data/overall_pipeline',
  config_base_directory   => 't/data/overall_conf',
  log_base_directory      => 't/data/overall_log',
  suffix                  => 'external',
  prefix                  => 'pathogen',
  environment             => 'test',
)->create()->print_cron(),'create a database and all files');

ok (-e 't/data/overall_conf/pathogen_abc123_external_pipeline.conf', 'toplevel pipeline config file created');
ok (-e 't/data/overall_conf/pathogen_abc123_external/store_lanes_to_nfs.conf', 'store lanes config file created');
ok (-e 't/data/overall_conf/pathogen_abc123_external/qc/qc_lanes.conf', 'qc lanes config file created');
ok (-e 't/data/overall_conf/pathogen_abc123_external/mapping/mapping_lanes.conf', 'mapping lanes config file created');


ok($tracking->destroy(), 'destroy everything');
ok (! -e 't/data/overall_conf/pathogen_abc123_external_pipeline.conf', 'toplevel pipeline config file deleted');
ok (! -e 't/data/overall_conf/pathogen_abc123_external/store_lanes_to_nfs.conf', 'store lanes config file deleted');
ok (! -e 't/data/overall_conf/pathogen_abc123_external/qc/qc_lanes.conf', 'qc lanes config file deleted');
ok (! -e 't/data/overall_conf/pathogen_abc123_external/mapping/mapping_lanes.conf', 'mapping lanes config file deleted');

done_testing();