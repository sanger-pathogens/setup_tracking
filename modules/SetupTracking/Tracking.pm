=head1 NAME

Tracking - Driver class which sets up a tracking datbase and all the assosiated files

=head1 SYNOPSIS

use SetupTracking::Tracking;

SetupTracking::Tracking->new(
  short_name => 'abc123',
)->create()->print_cron();

# also destroy();

=cut

package SetupTracking::Tracking;
use Moose;
use SetupTracking::Database;
use SetupTracking::Directories;
use SetupTracking::ConfigFiles;
use SetupTracking::Reporting;

has 'short_name'              => ( is => 'ro', isa => 'Str', required  => 1 );
                                                                      
has 'pipeline_base_directory' => ( is => 'rw', isa => 'Str', required  => 1 );
has 'config_base_directory'   => ( is => 'rw', isa => 'Str', required  => 1 );
has 'log_base_directory'      => ( is => 'rw', isa => 'Str', required  => 1 );
has 'prefix'                  => ( is => 'ro', isa => 'Str', required  => 1 );
has 'suffix'                  => ( is => 'ro', isa => 'Str', required  => 1 );
has 'environment'             => ( is => 'ro', isa => 'Str', required  => 1 );

has '_database_obj'           => ( is => 'rw', isa => 'SetupTracking::Database',    lazy_build => 1  );
has '_directories_obj'        => ( is => 'rw', isa => 'SetupTracking::Directories', lazy_build => 1  );
has '_config_files_obj'       => ( is => 'rw', isa => 'SetupTracking::ConfigFiles', lazy_build => 1  );

sub _build__database_obj
{
  my ($self) = @_;
  SetupTracking::Database->new(
    short_name  => $self->short_name,
    prefix      => $self->prefix,
    suffix      => $self->suffix,
    environment => $self->environment
  );
}

sub _build__directories_obj
{
  my ($self) = @_;
  SetupTracking::Directories->new(
     pipeline_base_directory => $self->pipeline_base_directory,
     config_base_directory   => $self->config_base_directory,
     log_base_directory      => $self->log_base_directory,
     database_name           => $self->_database_obj->name
    );
}

sub _build__config_files_obj
{
  my ($self) = @_;
  SetupTracking::ConfigFiles->new( directories_obj => $self->_directories_obj );
}


sub _create_database
{
  my ($self) = @_;
  $self->_database_obj->create_database->create_tables()->seed_database();
  return $self;
}

sub _create_directories
{
  my ($self) = @_;
  $self->_directories_obj->create_directories();
  return $self;
}

sub _create_config_files
{
  my ($self) = @_;
  $self->_config_files_obj->create_config_files();
  return $self;
}

sub print_cron
{
  my ($self) = @_;
  SetupTracking::Reporting->new(config_files_obj => $self->_config_files_obj)->print_cron();
  return $self;
}

sub create
{
  my ($self) = @_;
  $self->_create_database()->_create_directories()->_create_config_files();

  return $self;
}

sub destroy
{
  my ($self) = @_;
  $self->_config_files_obj->destroy_config_files();
  $self->_directories_obj->destroy_directories();
  $self->_database_obj->destory_database();
  return $self;
}

1;