#!/usr/bin/env perl

=head1 NAME

setup_tracking

=head1 SYNOPSIS

=head1 DESCRIPTION

Setup a new vrtrack pipeline. It creates a database, initally seeds it, creates directories, creates config files and outputs the line to add to the crontab.

=head1 CONTACT

path-help@sanger.ac.uk

=cut

# PODNAME: setup_tracking.pl

BEGIN { unshift(@INC, './lib') }
use strict;
use warnings;
no warnings 'uninitialized';
use Getopt::Long;
use SetupTracking::Tracking;


my($shortname, $pipeline_base_directory, $config_base_directory, $log_base_directory, $prefix, $suffix, $environment, $populate_assembly, $help );

GetOptions(
   'd|pipeline_base_directory=s' => \$pipeline_base_directory,
   'c|config_base_directory=s'   => \$config_base_directory,
   'l|log_base_directory=s'      => \$log_base_directory,
   'p|prefix=s'                  => \$prefix,
   's|suffix=s'                  => \$suffix,
   'e|environment=s'             => \$environment,
   'n|no_populate_assembly'      => \$populate_assembly,
   'h|help'                      => \$help
    );

$shortname = $ARGV[0];

(length($shortname) >= 3 && length($shortname) < 10 ) or die <<USAGE;

Usage: $0 [options] short_name
  -d|pipeline_base_directory  <Base directory for pipeline defaults to /lustre/scratch118/infgen/pathogen/pathpipe>
  -c|config_base_directory    <Config file directory, defaults to /nfs/pathnfs01/conf>
  -l|log_base_directory       <Log file directory, defaults to /nfs/pathnfs01/log>
  -p|prefix                   <prefix of database name, defaults to pathogen>
  -s|suffix                   <suffix of database name, defaults to external>
  -e|environment              <production or test, defaults to production>
  -n|no_populate_assembly     <do not populate assembly table>
  -h|help                     <print this message>

Defaults should be find for pathogens, so typical usage is:
$0 abc
which creates a database called pathogen_abc_external,
config files in /nfs/pathnfs01/conf/pathogen_abc_external
and pipeline files in /lustre/scratch118/infgen/pathogen/pathpipe/pathogen_abc_external/seq-pipelines

Setup a new vrtrack pipeline. It creates a database, initally seeds it, creates directories, creates config files and outputs the line to add to the crontab.
USAGE

$pipeline_base_directory ||= '/lustre/scratch118/infgen/pathogen/pathpipe' ;
$config_base_directory   ||= '/nfs/pathnfs05/conf';
$log_base_directory      ||= '/nfs/pathnfs05/log' ;
$prefix                  ||= 'pathogen';
$suffix                  ||= 'external';
$environment             ||= 'production';

my $assembly_file = $populate_assembly ? undef :'/lustre/scratch118/infgen/pathogen/pathpipe/refs/refs.index';

SetupTracking::Tracking->new(
  short_name              => $shortname,
  pipeline_base_directory => $pipeline_base_directory,
  config_base_directory   => $config_base_directory,
  log_base_directory      => $log_base_directory,
  prefix                  => $prefix,
  suffix                  => $suffix,
  environment             => $environment,
  assembly_file           => $assembly_file,
)->create()->print_cron();

