package ESocial::Controller::Comment;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Comment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Comment in Comment.');
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

sub regular_comment  {
	my ($c, $post_id) = (shift, shift);
	my $c_content = $c->request->params->{c_content};
	$c->model('ESocial::Comment')->create({
		post_id => $post_id,
		commenter => $c->user->id,
		content => $c_content
	});
}

=head2 craete_wall_comment

Creates a comment to a wall post

=cut

sub create_wall_comment :Local :Args(2) {
	my ($self, $c, $profile_id, $post_id) = @_;
	my $c_content = $c->request->params->{c_content};
	if(!$c_content) {
		$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $profile_id));
		return;	
	}
	regular_comment($c, $post_id);
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $profile_id));
}

=head2 craete_page_comment

Creates a comment to a wall post

=cut

sub create_page_comment :Local :Args(2) {
	my ($self, $c, $page_id, $post_id) = @_;
	my $c_content = $c->request->params->{c_content};
	if(!$c_content) {
		$c->response->redirect($c->uri_for($c->controller('Page')->action_for('get_page'), $page_id));
		return;	
	}
	regular_comment($c, $post_id);
	$c->response->redirect($c->uri_for($c->controller('Page')->action_for('get_page'), $page_id));
}
sub delete_comment {
	my ($c, $comment_id) = (shift, shift);
	my $comment = $c->model('ESocial::Comment')->find($comment_id);
	$comment->delete;
}

=head2 delete_wall_comment

Deletes comment from wall post

=cut

sub delete_wall_comment :Local :Args(2) {
	my ($self, $c, $profile_id, $comment_id) = @_;
	delete_comment($c, $comment_id);
	$c->response->redirect($c->uri_for($c->controller('Profile')->action_for('get_profile'), $profile_id));
}

=head2 delete_page_comment

Deletes comment from page post

=cut

sub delete_page_comment :Local :Args(2) {
	my ($self, $c, $page_id, $comment_id) = @_;
	delete_comment($c, $comment_id);
	$c->response->redirect($c->uri_for($c->controller('Page')->action_for('get_page'), $page_id));
}

__PACKAGE__->meta->make_immutable;

1;
