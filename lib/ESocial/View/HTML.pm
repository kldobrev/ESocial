package ESocial::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
	render_die => 1,
	TIMER => 0,
	WRAPPER => 'wrappers/wrapper.tt2',
);

=head1 NAME

ESocial::View::HTML - TT View for ESocial

=head1 DESCRIPTION

TT View for ESocial.

=head1 SEE ALSO

L<ESocial>

=head1 AUTHOR

Konstantin,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
