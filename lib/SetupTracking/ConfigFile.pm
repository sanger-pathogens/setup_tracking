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
extends 'SetupTracking::TemplateToolkitCommon';

has 'input_file_name'  => ( is => 'ro', isa => 'Str',            required => 1);
has 'output_file_name' => ( is => 'ro', isa => 'Str',            required => 1);
has 'params'           => ( is => 'ro', isa => 'Maybe[HashRef]', required => 1);


sub render_to_file
{
  my ($self) = @_;

  open(my $fh, $self->input_file_name) or die 'couldnt open input file '.$self->input_file_name;
  $self->_template->process($fh, $self->params, $self->output_file_name) || die $self->_template->error();
  return $self;
}

1;
