package ESocial::Controller::Post;
use Moose;
use namespace::autoclean;
use Switch;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Post - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Post in Post.');
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

sub regular_post {
	my ($c, $content) = (shift, shift);
	my $post = $c->model('ESocial::Post')->create({
		author => $c->user->id,
		content => $content
	});
	return $post;
}

=head2 create_wall_post

Creates a post on friend's wall

=cut

sub create_wall_post :Local :Args(1) {
	my ($self, $c, $profile_id) = @_;
	my $p_content = $c->request->params->{p_content};
	my $p_privacy = $c->request->params->{p_privacy} + 0;
	my $new_post = regular_post($c, $p_content);
	$c->model('ESocial::WallPost')->create({
		post_id => $new_post->id,
		wall_id => $profile_id,
		privacy_lev => $p_privacy
	});
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $profile_id));
}

sub delete_regular_post {
	my ($c, $post_id) = (shift, shift);
	my $post = $c->model('ESocial::Post')->find($post_id);
	$post->delete;
}

=head2 delete_post

Deletes a post by author and post id

=cut

sub delete_wall_post :Local :Args(2) {
	my ($self, $c, $post_id, $profile_id) = @_;
	delete_regular_post($c, $post_id);
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $profile_id));
}

__PACKAGE__->meta->make_immutable;

1;
