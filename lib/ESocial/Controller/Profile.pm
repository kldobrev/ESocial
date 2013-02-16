package ESocial::Controller::Profile;
use Moose;
use namespace::autoclean;
use Switch;

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

sub calc_age {
	my $bdate = shift;
	my ($c_day, $c_month, $c_year) = (localtime)[3..5];
	my $age = $c_year - $bdate->year;
	$age += 1900;
	$age-- if($c_month < $bdate->month && $c_day < $bdate->day);

	return $age;
}

sub button_values {
	my ($c, $profile) = (shift, shift);
	if($c->user->id == $profile->id) {
		$c->stash(is_own_profile => 1);
		my $action_str = $c->uri_for($c->controller->action_for('edit_profile'));
		return {controller => 'Profile', action => $action_str, name => 'Edit Profile'};
	}
	else {
		my $has_asked = $c->model('ESocial::FriendPair')->search({ user_id => $profile->id, friend_id => $c->user->id, status => 0})->single or 0;
		return 0 if $has_asked;
		my $f_pair = $c->model('ESocial::FriendPair')->find({ user_id => $c->user->id, friend_id => $profile->id}) or 0;
		my $action_str = $c->uri_for($c->controller('Friend')->action_for('ask_friend'), $profile->id);
		return {controller => 'Friend', action => $action_str, name => 'Make friends'} if($f_pair == 0);
		$action_str = $c->uri_for($c->controller('Friend')->action_for('cancel_request'), $profile->id);
		return {controller => 'Friend', action => $action_str, name => 'End request'} if($f_pair->status == 0);
		$action_str = $c->uri_for($c->controller('Friend')->action_for('unfriend'), $profile->id);
		return {controller => 'Friend', action => $action_str, name => 'Unfriend'};
	}
}

=head2 get_profile

Redirects user to main profile page

=cut

sub get_profile :Path('id') :Args(1) {
	my ($self, $c, $id) = @_;
	my $user_profile = $c->model('ESocial::UserProfile')->find($id);
	my $avatar = $c->uri_for('/static/avatar_pics/' . $user_profile->avatar_pic);
	my $gender;
	switch($user_profile->gender) {
		case 'M' { $gender = 'Male' }
		case 'F' { $gender = 'Female' }
		else { $gender = 'Not specified' }
	}
	if($user_profile->birthdate) {
		$c->stash(age => calc_age($user_profile->birthdate));	
	}
	my $but_vals = button_values($c, $user_profile);
	my $requests = $c->model('ESocial::FriendPair')->search({friend_id => $c->user->id, status => 0});
	my $friends = $c->model('ESocial::FriendPair')->search({user_id => $user_profile->id, status => 1})->slice(0..4);
	my $posts = $c->model('ESocial::WallPost')->search({wall_id => $id}, {order_by => {-desc => 'post_id'}});
	my $is_friend = $friends->search(friend_id => $c->user->id)->single or 0;

	$c->stash(but_vals => $but_vals);
	$c->stash(gender => $gender);
	$c->stash(avatar => $avatar);
	$c->stash(profile => $user_profile);
	$c->stash(requests => $requests);
	$c->stash(friends => $friends);
	$c->stash(posts => $posts);
	$c->stash(is_friend => $is_friend);
	$c->stash(template => 'profile/profile_data.tt2');
}

=head2 edit_profile

Action to edit profile

=cut

sub edit_profile :Path('edit') {
	my ($self, $c) = @_;
	$c->stash(gender => $c->user->user_profile->gender);
	$c->stash(template => 'profile/edit.tt2');
}

=head2 update_profile

Updating the profile after editing

=cut

sub update_profile :Path('uptate') {
	my ($self, $c) = @_;
	my $c_name = $c->request->params->{edit_name};
	my $c_location = $c->request->params->{edit_location};
	my $c_hometown = $c->request->params->{edit_hometown};
	my $c_about = $c->request->params->{edit_about};
	my $c_gender = $c->request->params->{edit_gender};
	my $c_showbd = $c->request->params->{edit_showbd};
	my $c_year = $c->request->params->{edit_year};
	my $c_month = $c->request->params->{edit_month};
	my $c_day = $c->request->params->{edit_day};
	my $user_profile = $c->user->user_profile;

	$user_profile->name($c_name);
	$user_profile->location($c_location);
	$user_profile->hometown($c_hometown);
	$user_profile->about($c_about);
	$user_profile->gender(($c_gender ne 'N') ? $c_gender : '');
	$user_profile->show_bdate(($c_showbd eq 'on') ? 1 : 0);
	$user_profile->birthdate("$c_year-$c_month-$c_day");
	if(my $upload = $c->req->upload('avatar')) {
		my $file_name = $upload->filename;
		my $directory = $c->uri_for('/static/avatar_pics/') . $file_name;
		$upload->copy_to($directory);
		$user_profile->avatar_pic($file_name);
	}
	
	$user_profile->update;
	$c->flash(status_msg => 'Changes saved');
	$c->response->redirect($c->uri_for('edit'));
}

=head2 get_create_page

Renders 'create content' template

=cut

sub get_create_page :Local {
	my ($self, $c) = @_;
	$c->stash(template => 'create_content.tt2');
}

=head2 delete_account

This action deletes all user data from the database. It felt so depressing to even think of writing such a horrible action...

=cut

sub delete_account :Local {
	my ($self, $c) = @_;
	my $doomed_user = $c->model('ESocial::User')->find($c->user->id);
	$c->user->logout;
	$doomed_user->delete;
	$c->response->redirect($c->uri_for('/'));
}

__PACKAGE__->meta->make_immutable;

1;
