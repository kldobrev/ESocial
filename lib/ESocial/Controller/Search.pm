package ESocial::Controller::Search;
use Moose;
use namespace::autoclean;
use Switch;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path('/search') :Args(0) {
    my ( $self, $c ) = @_;
	
	$c->stash(template => 'search.tt2');
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

sub results :Local {
	my ($self, $c) = @_;
	my $search_query = $c->request->params->{'search_query'};
	my $search_term = $c->request->params->{'search_term'};
	if(length($search_query) > 0) {
		my $result_set = [$c->model("ESocial::$search_term")->search(name => { like => "%$search_query%" })->all];
		$c->stash(result_set => $result_set);
	}
	$c->stash(template => 'search.tt2');
}

__PACKAGE__->meta->make_immutable;

1;
