=head1 NAME

Reporting - print out the cron to make the pipeline work

=head1 SYNOPSIS

use SetupTracking::Reporting;

SetupTracking::Reporting->new(
  config_files_obj => $config_files_obj,
)->print_cron();

=cut

package SetupTracking::Reporting;
use Moose;
extends 'SetupTracking::TemplateToolkitCommon';

has 'config_files_obj'   => ( is => 'ro', isa => 'SetupTracking::ConfigFiles', required   => 1 );


sub _render_to_string
{
  my ($self, $input_file_name,$params) = @_;
  my $output = '';
  open(my $fh, $input_file_name) or die 'couldnt open input file '.$input_file_name;
  $self->_template->process($fh, $params, \$output) || die $self->_template->error();
  return $output;
}

sub _generate_cron_string
{
  my ($self) = @_;
  return $self->_render_to_string("views/run_pipeline_cron", 
    {
      config_file => $self->config_files_obj->top_level_config_file,
      log_file    => join('/',($self->config_files_obj->database_log_directory, 'run_pipeline.log')),
      lock_file   => join('/',($self->config_files_obj->database_log_directory, '.pipeline.lock')),
    });
}

sub print_cron
{
  my ($self) = @_;
  print 'Add this line to the crontab on pathpipe@pathinfo'."\n";
  print $self->_generate_cron_string;
  print "\n";
 
  return $self; 
}

1;
