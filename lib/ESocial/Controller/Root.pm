package ESocial::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

ESocial::Controller::Root - Root Controller for ESocial

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 begin

Beginning actions

=cut

sub begin :Private {
	my ($self, $c) = @_;
	$c->stash(wrapper => 'wrappers/global.tt2');	
}

=head2 index

The root page (/)

=cut

sub index :Path('/') :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->stash(template => 'index.tt2');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Konstantin,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

=head2 about

Render 'about' page

=cut

sub about :Path('/about') {
	my ($self, $c) = @_;
	$c->stash(template => 'about.tt2');
}

=head2 help

Render 'help' page

=cut

sub help :Path('/help') {
	my ($self, $c) = @_;
	$c->stash(template => 'help.tt2');
}

=head2 auto

Default action redirects guests or non logged useres to index page

=cut

sub auto :Private {
	my ($self, $c) = @_;
#	return 1 if($c->controller eq $c->controller('Users'));
#	if(!$c->user_exists) {
#		$c->response->redirect('index');
#		return 0;
#	}
	return 1;
}

__PACKAGE__->meta->make_immutable;

1;
