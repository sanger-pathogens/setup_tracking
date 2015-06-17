#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('SetupTracking::Database');
    use_ok('SetupTracking::Database::PopulateAssembly');
}

# create test database
ok my $database = SetupTracking::Database->new( short_name => 'mytest' ), 'initialise database object ';
ok $database->create_database, 'create test tracking database';
ok $database->create_tables,   'create tables';

# initialise valid object
ok my $populate_assembly = SetupTracking::Database::PopulateAssembly->new(
    dbh  => $database->_dbh,
    file => 't/data/refs.index',
    ), 'initialise valid object';
ok my $fh = $populate_assembly->_fh, 'opened filehandle';
ok $populate_assembly->populate_table(), 'populate_table returns true';
ok my $assembly_arrayref = $populate_assembly->_assemblies , 'assemblies array generated';

# expected results
my @expected_result = (['Acinetobacter_baumannii',        4001457],
		       ['Actinobacillus_pleuropneumoniae',2274482]);

# confirm object array correct
my $array_check = 0;
for(my $i=0; $i < @$assembly_arrayref; $i++)
{
    if($assembly_arrayref->[$i][0] eq $expected_result[$i][0] && 
       $assembly_arrayref->[$i][1] == $expected_result[$i][1] )    
    {
	$array_check++;
    }
}
is $array_check, scalar @expected_result, 'assembly array correct';

# query assembly table
my $sth = $database->_dbh->prepare("select name, reference_size from assembly");
$sth->execute;
ok my $table_arrayref = $sth->fetchall_arrayref, 'query assembly table';

# confirm table correct
my $table_check = 0;
for(my $i=0; $i < @$table_arrayref; $i++)
{
    if($table_arrayref->[$i][0] eq $expected_result[$i][0] && 
       $table_arrayref->[$i][1] == $expected_result[$i][1] )
    {
	$table_check++;
    }
}
is $table_check, scalar @expected_result, 'assembly table correct';

ok $database->destory_database(), 'remove test database' ;

done_testing();
