package ESocial::Controller::Page;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Page - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Page in Page.');
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

=head2 get_page

Retreive a page

=cut

sub get_page :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	my $page = $c->model('ESocial::FanPage')->find($page_id);
	my $is_fan = $c->model('ESocial::PageLike')->search(profile_id => $c->user->id, page_id => $page_id)->single;
	my $fans_num = $c->model('ESocial::PageLike')->search(page_id => $page_id)->count;
	my $posts = $c->model('ESocial::PagePost')->search({page_id => $page_id}, {order_by => {-desc => 'post_id'}});
	my $is_creator = ($c->user->id == $page->creator->id) ? 1 : 0;
	$c->stash(is_fan => 1) if ($is_fan);
	$c->stash(page => $page);
	$c->stash(fans_num => $fans_num);
	$c->stash(posts => $posts);
	$c->stash(is_creator => $is_creator);
	$c->stash(template => 'pages/page.tt2');
}

=head2 create_page

Create a page

=cut

sub create_page :Local {
	my ($self, $c) = @_;
	my $p_name = $c->request->params->{p_name};
	my $p_about =  $c->request->params->{p_about};
	my $page = $c->model('ESocial::FanPage')->create({
		creator => $c->user->id, 
		name => $p_name,
		about => $p_about
	});
	$c->response->redirect($c->uri_for($c->controller('Page')->action_for('get_page'), $page->id));
}

=head2 edit_page

Edit a page

=cut

sub edit_page :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	my $page = $c->model('ESocial::FanPage')->find($page_id);
	$c->stash(page => $page);
	$c->stash(template => 'pages/edit.tt2');
}

=head2 save_page

Saves changes made to page during editing

=cut

sub save_page :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	my $p_about = $c->request->params->{p_about};
	my $page = $c->model('ESocial::FanPage')->find($page_id);
	$page->about($p_about);
	$page->update;
	$c->response->redirect($c->uri_for($c->controller('Page')->action_for('get_page'), $page_id));
}

=head2 like_page

Creates a record in the PageLike table

=cut

sub like_page :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	$c->model('ESocial::PageLike')->create({
		profile_id => $c->user->id,
		page_id => $page_id
	});
	$c->response->redirect($c->uri_for($c->controller->action_for('get_page'), $page_id));
}

=head2 unlike_page

Deletes like record for user in DB

=cut

sub unlike_page :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	my $like = $c->model('ESocial::PageLike')->search(profile_id => $c->user->id, page_id => $page_id)->single;
	$like->delete;
	$c->response->redirect($c->uri_for($c->controller->action_for('get_page'), $page_id));
}

=head2 get_fan_list

Returns a list of all fans of the page

=cut

sub get_fan_list :Local :Args(1) {
	my ($self, $c, $page_id) = @_;
	my $fans = $c->model('ESocial::PageLike')->search(page_id => $page_id);
	$c->stash(fans => $fans);
	$c->stash(page_id => $page_id);
	$c->stash(template => 'pages/fans.tt2');
}

__PACKAGE__->meta->make_immutable;

1;
