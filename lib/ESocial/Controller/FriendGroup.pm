package ESocial::Controller::FriendGroup;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::FriendGroup - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::FriendGroup in FriendGroup.');
}


=head1 AUTHOR

Konstantin,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

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

=head2 create_group

Create a group for a user

=cut

sub create_group :Local {
	my ($self, $c) = @_;
	my $group_name = $c->request->params->{group_name};
	$c->model('ESocial::FriendGroup')->create({
		user_id => $c->user->id,
		name => $group_name
		});
		$c->response->redirect($c->uri_for($c->controller('Friend')->action_for('friend_list'), $c->user->id));
}

=head2 get_group

Access a friend group

=cut

sub get_group :Local :Args(2) {
	my ($self, $c, $profile_id ,$group_name) = @_;
	my $friends_in_gr = $c->model('ESocial::FriendGroupMember')->search(user_id => $profile_id, name => $group_name);
	my @compare_arr = map { $_->friend_id } ($friends_in_gr->all);
	my $free_friends = $c->model('ESocial::FriendPair')->search(user_id => $c->user->id, friend_id => { -not_in => [@compare_arr] });
	$c->stash(group_name => $group_name);
	$c->stash(profile_id => $profile_id);
	$c->stash(friends => $friends_in_gr);
	$c->stash(not_included_fr => $free_friends);
	$c->stash(template => 'friends/group.tt2');
}

=head2 delete_group

Delete a group and remove all users from it

=cut

sub delete_group :Local :Args(1) {
	my ($self, $c, $group_name) = @_;
	my $friends_in = $c->model('ESocial::FriendGroupMember')->search({user_id => $c->user->id, name => $group_name});
	map { $_->delete } ($friends_in->all);
	my $group = $c->model('ESocial::FriendGroup')->find({user_id => $c->user->id, name => $group_name});
	$group->delete;
	$c->response->redirect($c->uri_for($c->controller('Friend')->action_for('friend_list'), $c->user->id));
}

=head2 add_friend

Add a friend to the current group

=cut

sub add_friend :Local :Args(2) {
	my ($self, $c, $group_name, $friend_id) = @_;
	my $pair = $c->model('ESocial::FriendGroupMember')->create({
		user_id => $c->user->id,
		name => $group_name,
		friend_id => $friend_id
	});
	$c->response->redirect($c->uri_for($c->controller->action_for('get_group'), $c->user->id, $group_name));
}

=head2 remove_friend

Remove a friend from a group

=cut

sub remove_friend :Local :Args(2) {
	my ($self, $c, $group_name, $friend_id) = @_;
	my $pair = $c->model('ESocial::FriendGroupMember')->find({user_id => $c->user->id, name => $group_name, friend_id => $friend_id});
	$pair->delete;
	$c->response->redirect($c->uri_for($c->controller->action_for('get_group'), $c->user->id, $group_name));
}

__PACKAGE__->meta->make_immutable;

1;
