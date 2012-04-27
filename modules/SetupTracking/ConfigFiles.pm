=head1 NAME

ConfigFiles- render the config files using template toolkit

=head1 SYNOPSIS

use SetupTracking::ConfigFiles;

SetupTracking::ConfigFiles->new(
  directories_obj => $directories_obj,
)->create_config_files();

=cut

package SetupTracking::ConfigFiles;
use Moose;
use SetupTracking::ConfigFile;
extends 'SetupTracking::Database::Settings';

has 'directories_obj'   => ( is => 'ro', isa => 'SetupTracking::Directories', required   => 1 );


sub create_config_files
{
  my ($self) = @_;
  $self->_create_stored_lanes_file;
  $self->_create_qc_lanes_file;
  $self->_create_mapping_lanes_file;
  $self->_create_pipeline_file;

  return $self;
}

sub top_level_config_file
{
  my ($self) = @_;
  join('/', ($self->directories_obj->config_base_directory, $self->directories_obj->database_name.'_pipeline.conf')) ;
}

sub mapping_config_file
{
  my ($self) = @_;
  join('/', ($self->directories_obj->database_config_directory, 'mapping', 'mapping_lanes.conf'));
}

sub qc_config_file
{
  my ($self) = @_;
  join('/', ($self->directories_obj->database_config_directory, 'qc', 'qc_lanes.conf'));
}

sub stored_config_file
{
  my ($self) = @_;
 join('/', ($self->directories_obj->database_config_directory, 'store_lanes_to_nfs.conf'));
}


sub database_log_directory
{
  my ($self) = @_;
  join('/', ($self->directories_obj->database_log_directory)), 
}

sub _create_pipeline_file
{
  my ($self) = @_;
  SetupTracking::ConfigFile->new(
    input_file_name    => 'views/pipeline.conf',
    output_file_name   => $self->top_level_config_file ,
    params             => {
      store_lanes        => $self->stored_config_file,
      qc_lanes           => $self->qc_config_file,
      mapping_lanes      => $self->mapping_config_file,
    },
  )->render_to_file();
  return $self;
}

sub _create_qc_lanes_file
{
  my ($self) = @_;
  SetupTracking::ConfigFile->new(
    input_file_name    => 'views/qc_lanes.conf',
    output_file_name   => $self->qc_config_file,
    params             => {
      root               => $self->directories_obj->database_pipeline_directory,
      log                => join('/', ($self->database_log_directory, 'qc_lanes.log')),
      database_name      => $self->directories_obj->database_name,
      database_host      => $self->_database_settings->{host},
      database_port      => $self->_database_settings->{port},
      database_user      => $self->_database_settings->{user},
      database_password  => $self->_database_settings->{password},
    },
  )->render_to_file();
  return $self;
}

sub _create_mapping_lanes_file
{
  my ($self) = @_;
  SetupTracking::ConfigFile->new(
    input_file_name    => 'views/mapping_lanes.conf',
    output_file_name   => $self->mapping_config_file,
    params             => {
      root               => $self->directories_obj->database_pipeline_directory,
      log                => join('/', ($self->database_log_directory, 'mapping_lanes.log')),
      database_name      => $self->directories_obj->database_name,
      database_host      => $self->_database_settings->{host},
      database_port      => $self->_database_settings->{port},
      database_user      => $self->_database_settings->{user},
      database_password  => $self->_database_settings->{password},
    },
  )->render_to_file();
  return $self;
}

sub _create_stored_lanes_file
{
  my ($self) = @_;
  SetupTracking::ConfigFile->new(
    input_file_name    => 'views/store_lanes_to_nfs.conf',
    output_file_name   => $self->stored_config_file,
    params             => {
      root               => $self->directories_obj->database_pipeline_directory,
      log                => join('/', ($self->database_log_directory, 'store_lanes_to_nfs.log')),
      database_name      => $self->directories_obj->database_name,
      database_host      => $self->_database_settings->{host},
      database_port      => $self->_database_settings->{port},
      database_user      => $self->_database_settings->{user},
      database_password  => $self->_database_settings->{password},
    },
  )->render_to_file();
  return $self;
}


sub destroy_config_files
{
  my ($self) = @_;
  unlink($self->top_level_config_file);
  unlink($self->stored_config_file   );
  unlink($self->qc_config_file       );
  unlink($self->mapping_config_file  );
}


1;
