use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::Messages;

ok( request('/messages')->is_success, 'Request should succeed' );
done_testing();
