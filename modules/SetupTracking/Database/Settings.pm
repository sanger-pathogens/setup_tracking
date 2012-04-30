package SetupTracking::Database::Settings;
use Moose;
use Pathogens::ConfigSettings;

has 'environment'         => ( is => 'ro', isa => 'Str',     default    => 'test');
has '_database_settings'  => ( is => 'ro', isa => 'HashRef', lazy_build => 1 );

sub _build__database_settings
{
  my ($self) = @_;
  return \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'database.yml')->settings()};
}

1;