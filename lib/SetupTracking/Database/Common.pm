=head1 NAME

Database::Common.pm - Common database functionality

=head1 SYNOPSIS

use SetupTracking::Database::Common;
my $database = SetupTracking::Database::Common->new(
  environment => 'test',
  short_name => 'somename'
  );
  $database->_dbh();
  $database->name();

=cut
package SetupTracking::Database::Common;
use Moose;
use Pathogens::ConfigSettings;
use DBI;
use DBD::mysql;
extends 'SetupTracking::Database::Settings';

has 'short_name'          => ( is => 'ro', isa => 'Str', required   => 1 );
has 'prefix'              => ( is => 'ro', isa => 'Str', default    => 'pathogen' );
has 'suffix'              => ( is => 'ro', isa => 'Str', default    => 'external' );
                                                         
has '_dbh'                => ( is => 'ro',               lazy_build => 1 );
has 'name'                => ( is => 'ro', isa => 'Str', lazy_build => 1 );

sub _build_name
{
  my ($self) = @_;
  return join('_',($self->prefix , $self->short_name, $self->suffix));
}

sub _build__dbh
{
  my ($self) = @_;
  my $name = $self->name;
  my $host = $self->_database_settings->{host};
  my $port = $self->_database_settings->{port};
  return DBI->connect("DBI:mysql:host=$host:port=$port;database=$name", $self->_database_settings->{user}, $self->_database_settings->{password}, {'RaiseError' => 1, 'PrintError'=>0});
}

1;
