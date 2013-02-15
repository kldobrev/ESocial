use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::FriendGroup;

ok( request('/friendgroup')->is_success, 'Request should succeed' );
done_testing();
