use strict;
use warnings;

use ESocial;

my $app = ESocial->apply_default_middlewares(ESocial->psgi_app);
$app;

