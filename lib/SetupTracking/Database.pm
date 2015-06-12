=head1 NAME

Database.pm - Create a tracking database

=head1 SYNOPSIS

use SetupTracking::Database;
my $database = SetupTracking::Database->new(
  short_name => 'prok',
  );
  $database->name();
  $database->create_database->create_tables()->seed_database();

=cut
package SetupTracking::Database;
use Moose;
use VRTrack::VRTrack;
use DBI;
use DBD::mysql;
use SetupTracking::Database::Seed;
use SetupTracking::Database::PopulateAssembly;
extends 'SetupTracking::Database::Common';

sub create_database
{
  my ($self) = @_;

  my $host = $self->_database_settings->{host};
  my $port = $self->_database_settings->{port};
  my $dbh_without_database_name = DBI->connect("DBI:mysql:host=$host:port=$port", $self->_database_settings->{user}, $self->_database_settings->{password}, {'RaiseError' => 1, 'PrintError'=>0});
  
  $dbh_without_database_name->do("CREATE DATABASE ".$self->name);
  return $self;
}

sub create_tables
{
  my ($self) = @_;

  foreach (VRTrack::VRTrack->schema()) 
  { 
    $self->_dbh->do($_); 
  }
  
  return $self;
}

sub seed_database
{
  my ($self) = @_;
  SetupTracking::Database::Seed->new(_dbh => $self->_dbh)->seed_database(); 
  return $self;
}

sub populate_assembly
{
    my ($self, $assembly_file) = @_;
    SetupTracking::Database::PopulateAssembly->new( dbh => $self->_dbh, file => $assembly_file )->populate_table();
    return $self;
}

sub destory_database
{
  my ($self) = @_;
  $self->_dbh->do("drop database ".$self->name);
  return $self;
}


1;
