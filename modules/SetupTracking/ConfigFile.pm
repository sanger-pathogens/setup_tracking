=head1 NAME

ConfigFile- render a config file using template toolkit

=head1 SYNOPSIS

use SetupTracking::ConfigFile;

SetupTracking::ConfigFile->new(
     input_file_name    => 'my_input_file_name',
     output_file_name   => 'my_output_file_name',
     params             => \%myhash,
)->render_to_file();
=cut

package SetupTracking::ConfigFile;
use Moose;
use Template;

has 'input_file_name'  => ( is => 'ro', isa => 'Str',            required => 1);
has 'output_file_name' => ( is => 'ro', isa => 'Str',            required => 1);
has 'params'           => ( is => 'ro', isa => 'Maybe[HashRef]', required => 1);

has '_template'        => ( is => 'ro', isa => 'Template',       lazy_build => 1);

sub _build__template
{
  my ($self) = @_;

  my $config = {
      INTERPOLATE  => 1,  # expand "$var" in plain text
      POST_CHOMP   => 1,  # cleanup whitespace
      EVAL_PERL    => 1,  # evaluate Perl code blocks
  };

  Template->new($config);
}

sub render_to_file
{
  my ($self) = @_;
  my $output = '';
  
  open(my $fh, $self->_input_file_name) or die 'couldnt open input file '.$self->_input_file_name;
  $self->_template->process($fh, $self->params, \$output)
       ->output($self->output_file_name) || die $self->_template->error();
  $output;
}

1;
