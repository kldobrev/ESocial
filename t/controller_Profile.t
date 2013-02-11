use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::Profile;

ok( request('/profile')->is_success, 'Request should succeed' );
done_testing();
