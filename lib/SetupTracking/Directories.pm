=head1 NAME

Directories.pm - Create the nessisary directories

=head1 SYNOPSIS

use SetupTracking::Directories;
my $directories = SetupTracking::Directories->new(
  pipeline_base_directory => '/lustre/scratch123/pathogen/pathpipe',
  config_base_directory   => '/nfs/pathnfs/conf',
  log_base_directory      => '/nfs/log',
  database_name           => 'pathogen_abc_track'
  )->create_directories;


=cut
package SetupTracking::Directories;
use Moose;
use File::Path qw(make_path rmtree);

has 'pipeline_base_directory' => ( is => 'ro', isa => 'Str', required   => 1 );
has 'config_base_directory'   => ( is => 'ro', isa => 'Str', required   => 1 );
has 'log_base_directory'      => ( is => 'ro', isa => 'Str', required   => 1 );
has 'database_name'           => ( is => 'ro', isa => 'Str', required   => 1 );

has 'database_config_directory'   => ( is => 'ro', isa => 'Str', lazy_build   => 1 );
has 'database_pipeline_directory' => ( is => 'ro', isa => 'Str', lazy_build   => 1 );
has 'database_log_directory'      => ( is => 'ro', isa => 'Str', lazy_build   => 1 );

sub _build_database_log_directory
{
  my ($self) = @_;
  join('/', ($self->log_base_directory, $self->database_name) );
}

sub _build_database_pipeline_directory
{
  my ($self) = @_;
  join('/', ($self->pipeline_base_directory, $self->database_name, 'seq-pipelines') ) ;
}

sub _build_database_config_directory
{
  my ($self) = @_;
  join('/', ($self->config_base_directory, $self->database_name));
}

sub _directories_to_make
{
  my($self) = @_;
  my @directories;
  
  # base data directory
  push(@directories, $self->database_pipeline_directory );
  
  # config directories
  push(@directories, $self->database_config_directory );
  push(@directories, join('/', ($self->database_config_directory, 'mapping' ) ) );
  push(@directories, join('/', ($self->database_config_directory, 'assembly') ) );
  push(@directories, join('/', ($self->database_config_directory, 'snps'    ) ) );
  push(@directories, join('/', ($self->database_config_directory, 'qc'      ) ) );
  push(@directories, join('/', ($self->database_config_directory, 'rna_seq' ) ) );
  
  # log directories
  push(@directories, $self->database_log_directory );
  
  \@directories;
}

sub create_directories
{
  my($self) = @_;
  for my $directory_name (@{$self->_directories_to_make})
  { 
    make_path($directory_name , {mode => 0775});
  }
  return $self;
}

sub destroy_directories
{
  my($self) = @_;
  for my $directory_name (@{$self->_directories_to_make})
  { 
    rmtree($directory_name);
  }
  return $self;
}

1;