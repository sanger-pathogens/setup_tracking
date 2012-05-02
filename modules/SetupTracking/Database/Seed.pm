=head1 NAME

Database::Seed.pm - Seed a database with basic initial data. Can only really be done once per database. Add MySQL statements at the end of this file.

=head1 SYNOPSIS

use SetupTracking::Database::Seed;
SetupTracking::Database::Seed->new(_dbh => $dbh)->seed_database;

=cut

package SetupTracking::Database::Seed;
use Moose;  

has '_dbh' => ( is => 'ro', required => 1 );

sub seed_database
{
  my($self) = @_; 
  foreach (@{$self->_parse_sql_into_array}) 
  { 
    $self->_dbh->do($_); 
  } 
  
  return $self;
}

sub _parse_sql_into_array 
{
  my($self) = @_;
  my @sql;
  
  my $line = '';
  while (<DATA>) {
      chomp;
      next if /^--/;
      next unless /\S/;
      $line .= $_;
      if (/;\s*$/) {
          push(@sql, $line."\n");
          $line = '';
      }
  }
  if ($line =~ /;\s*$/) {
      push(@sql, $line);
  }
  
  return \@sql;
}
1;

__DATA__

INSERT INTO `population` (`population_id`, `name`)
VALUES	(1,'Population');

INSERT INTO `seq_centre` (`seq_centre_id`, `name`)
VALUES	(1,'SC');

INSERT INTO `seq_tech` (`seq_tech_id`, `name`)
VALUES	(1,'SLX');

INSERT INTO `project` (`project_id`,`ssid`,`name`, `hierarchy_name`,`study_id`,`changed`,`latest`)
VALUES	(1,1,'Study','Study',1,NOW(),1);

INSERT INTO `study` (`study_id`, `name`)
VALUES	(1,'');