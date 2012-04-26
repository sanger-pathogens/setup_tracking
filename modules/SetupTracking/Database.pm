=head1 NAME

Database.pm - Create a tracking database

=head1 SYNOPSIS

use SetupTracking::Database;
my $database = SetupTracking::Database->new(
  short_name => 'prok',
  );
  $database->name();
  $database->create_database->create_tables();

=cut
package SetupTracking::Database;
use Moose;
use VRTrack::VRTrack;
use DBI;
use DBD::mysql;
extends 'SetupTracking::DatabaseCommon';

sub create_database
{
  my ($self) = @_;

  my $host = $self->_database_settings->{host};
  my $port = $self->_database_settings->{port};
  my $dbh_without_database_name = DBI->connect("DBI:mysql:host=$host:port=$port", $self->_database_settings->{user}, $self->_database_settings->{password}, {'RaiseError' => 1, 'PrintError'=>0});
  
  $dbh_without_database_name->do("CREATE DATABASE ".$self->name);
  $dbh_without_database_name->do("FLUSH PRIVILEGES");
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


1;