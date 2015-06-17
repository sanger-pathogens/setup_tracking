=head1 NAME

Database::PopulateAssembly.pm - Populate tracking database assembly table.

=head1 SYNOPSIS

use SetupTracking::Database::PopulateAssembly;
SetupTracking::Database::PopulateAssembly->new( dbh => $dbh, file => 'refs.index')->populate_table();

=cut

package SetupTracking::Database::PopulateAssembly;
use Moose;  

has 'dbh'         => ( is => 'ro',               required => 1 );
has 'file'        => ( is => 'ro', isa => 'Str', required => 1 );
has '_fh'         => ( is => 'ro', isa => 'FileHandle', lazy_build => 1 );
has '_assemblies' => ( is => 'ro', isa => 'ArrayRef',   lazy_build => 1 );

sub _build__fh
{
  my($self) = @_;
  
  open(my $fh,"<",$self->file) or die "Cannot open index file '".$self->file."': $!\n";
  return $fh;
}

sub _build__assemblies
{
  my($self) = @_;
  my @assemblies = ();

  while(my $line = readline $self->_fh)
  {
      chomp $line;
      my($ref_name, $ref_fa_file) = split(/\s+/,$line);
      $ref_name    =~ s/\s+//gi;
      $ref_fa_file =~ s/\s+//gi;
      my $ref_size = $self->_get_ref_size($ref_fa_file);
      push @assemblies, [$ref_name, $ref_size];
  }

  return \@assemblies;
}

sub _get_ref_size
{
    my ($self,$ref_fa_file) = @_;

    open(my $fh,"<",$ref_fa_file.'.ann') or die "Cannot open file '$ref_fa_file.ann': $!\n";
    my $line = <$fh>;
    my @line_data = split(/\s+/,$line);
    close $fh;

    return $line_data[0];
}

sub populate_table
{
  my($self) = @_;

  for my $row (@{$self->_assemblies})
  {
      my $assembly      = $$row[0];
      my $assembly_size = $$row[1];
      my $sql = qq[insert into assembly (name, reference_size) values ('$assembly', $assembly_size)];
      $self->dbh->do($sql);
  }

  return 1;
}

1;
