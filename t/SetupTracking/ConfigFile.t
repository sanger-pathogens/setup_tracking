#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('SetupTracking::ConfigFile');
}

ok (SetupTracking::ConfigFile->new(
     input_file_name    => 't/data/test_view',
     output_file_name   => 't/data/test_view_rendered_output',
     params             => {
       text_to_insert => 'hello world',
     },
)->render_to_file(), 'render a file with template toolkit');

ok open(IN, 't/data/test_view_rendered_output') or die "Couldnt open output file";
my $first_line = <IN>;
chomp($first_line);
is $first_line, "test hello world", 'output rendered correctly';


unlink('t/data/test_view_rendered_output');
done_testing();
