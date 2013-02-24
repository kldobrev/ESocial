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
	$c->stash(page => $page);
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

__PACKAGE__->meta->make_immutable;

1;
