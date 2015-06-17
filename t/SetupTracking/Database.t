#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('SetupTracking::Database');
}

ok my $database = SetupTracking::Database->new(
  short_name => 'mytest',
  ), 'initialise valid object';
is  $database->name(), "pathogen_mytest_external", 'generated name';

ok $database->create_database, 'create the database';
ok $database->create_tables, 'create vrtrack tables';
ok $database->seed_database(), 'seed the database';

ok $database->_dbh->do("select * from schema_version"),'can connect to the database and perform a simple query';

# check database is seeded
ok (my $sth = $database->_dbh->prepare("select * from population"), 'lookup the population table to see if its been seeded');
$sth->execute;
is 1, $sth->rows, 'default population row returned';

# check populate assembly
ok $database->populate_assembly('t/data/refs.index'), 'populate assembly table';

ok $database->destory_database, 'remove tempory database';

ok $database = SetupTracking::Database->new(
  short_name => 'mytest',
  prefix => 'anotherprefix',
  suffix => 'changedsuffix'
  ), 'initialise valid object with supplied prefix and suffix';
is  $database->name(), "anotherprefix_mytest_changedsuffix", 'generated name with supplied prefix and suffix';

done_testing();
