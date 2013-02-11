package ESocial::Controller::Profile;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Profile - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Profile in Profile.');
}


=head1 AUTHOR

Konstantin,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 auto

Deny access to unauthenticated users

=cut

sub auto :Private {
	my ($self, $c) =@_;
	if(!$c->user_exists) {
		$c->response->redirect($c->uri_for('/'));
		return 0;
	}
	return 1;
}

=head2 begin

Starting actions for controller

=cut

sub begin :Private {
	my ($self, $c) = @_;
	$c->stash(wrapper => 'wrappers/logged.tt2');
}

=head2 main

Redirects user to main profile page

=cut

sub get_profile :Chained('/') :Path('id') :CaptureArgs(1) {
	my ($self, $c, $id) = @_;
	my $user_profile = $c->model('ESocial::UserProfile')->find($id);
	$c->stash(profile => $user_profile);
	$c->stash(template => 'profile/profile_data.tt2')
} 

__PACKAGE__->meta->make_immutable;

1;
