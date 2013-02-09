package ESocial::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Users in Users.');
}


=head1 AUTHOR

Konstantin,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 register

Create a new user and profile record in the database

=cut

sub register :Path('/register') {
	my ($self, $c) = @_;
	my $email = $c->request->params->{reg_email};
	my $password = $c->request->params->{reg_pass};
	my $rep_password = $c->request->params->{reg_rep_pass};
	my $user = $c->model('ESocial::User')->create({
		email => $email,
		password => $password,
	});
	$c->stash(template => 'index.tt2');
}


__PACKAGE__->meta->make_immutable;

1;
