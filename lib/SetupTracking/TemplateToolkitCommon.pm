=head1 NAME

TemplateToolkitCommon- Setup a template for use when rendering

=head1 SYNOPSIS

extends 'SetupTracking::TemplateToolkitCommon';

=cut

package SetupTracking::TemplateToolkitCommon;
use Moose;
use Template;
has '_template'        => ( is => 'ro', isa => 'Template',       lazy_build => 1);

sub _build__template
{
  my ($self) = @_;

  my $config = {
      INTERPOLATE  => 1,  # expand "$var" in plain text
      POST_CHOMP   => 0,  # cleanup whitespace
      EVAL_PERL    => 1,  # evaluate Perl code blocks
  };

  Template->new($config);
}
1;