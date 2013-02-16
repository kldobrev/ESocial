use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ESocial';
use ESocial::Controller::Page;

ok( request('/page')->is_success, 'Request should succeed' );
done_testing();
