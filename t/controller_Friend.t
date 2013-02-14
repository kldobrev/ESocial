use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::Friend;

ok( request('/friend')->is_success, 'Request should succeed' );
done_testing();
