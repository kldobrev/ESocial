package ESocial::Controller::Friend;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Friend - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Friend in Friend.');
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


=head2 ask_friend

Implements frend requests

=cut

sub ask_friend :Local :Args(1) {
	my ($self, $c, $friend_id) = @_;
	$c->model('ESocial::FriendPair')->create({
		user_id => $c->user->id,
		friend_id => $friend_id,
		status => 0,
	});
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $friend_id));
}

=head2 unfriend

Deletes friiend request from database

=cut

sub cancel_request :Local :Args(1) {
	my ($self, $c, $friend_id) = @_;
	my $request = $c->model('ESocial::FriendPair')->find({user_id => $c->user->id, friend_id => $friend_id, status => 0});
	$request->delete;
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $friend_id));
}

=head2 unfriend

Deletes friendship from the database

=cut

sub unfriend :Local :Args(1) {
	my ($self, $c, $friend_id) = @_;
	my $friendship = $c->model('ESocial::FriendPair')->find({user_id => $c->user->id, friend_id => $friend_id, status => 1});
	$friendship->delete;
	my $friendship_snd = $c->model('ESocial::FriendPair')->find({user_id => $friend_id, friend_id => $c->user->id, status => 1});
	$friendship_snd->delete;
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $friend_id));
}

=head2 accept

Change friendship status in dadtabase to true

=cut

sub accept :Local :Args(1) {
	my ($self, $c, $friend_id) = @_;
	my $request = $c->model('ESocial::FriendPair')->find({user_id => $friend_id, friend_id => $c->user->id, status => 0});
	$request->status(1);
	$request->update;
	$c->model('ESocial::FriendPair')->create({
		user_id => $c->user->id,
		friend_id => $friend_id,
		status => 1,
	});
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $friend_id));
}

=head 2 decline

Delete friedship request from database

=cut

sub decline :Local :Args(1) {
	my ($self, $c, $friend_id) = @_;
	my $request = $c->model('ESocial::FriendPair')->find({user_id => $friend_id, friend_id => $c->user->id, status => 0});
	$request->delete;
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $friend_id));
}

=head2 friend_list

View list of all ou the user's friends

=cut

sub friend_list :Local :Args(1) {
	my ($self, $c, $user_id) = @_;
	my $friend_l = $c->model('ESocial::FriendPair')->search(friend_id => $user_id);
	my $group_l = $c->model('ESocial::FriendGroup')->search(user_id => $user_id);
	$c->stash(profile_id => $user_id);
	$c->stash(friends => $friend_l);
	$c->stash(friend_groups => $group_l);
	$c->stash(template => 'friends/all.tt2');
}

__PACKAGE__->meta->make_immutable;

1;
