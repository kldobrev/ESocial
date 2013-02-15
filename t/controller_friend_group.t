use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::friend_group;

ok( request('/friend_group')->is_success, 'Request should succeed' );
done_testing();
