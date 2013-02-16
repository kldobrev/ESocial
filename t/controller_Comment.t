use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::Comment;

ok( request('/comment')->is_success, 'Request should succeed' );
done_testing();
