package ESocial::Controller::Messages;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Messages - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ESocial::Controller::Messages in Messages.');
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

=head2 message_list

Get all of user's messages

=cut

sub message_list :Local {
	my ($self, $c) = @_;
	my $messages = $c->model('ESocial::Message')->search({to_id => $c->user->id}, {order_by => { -desc => 'created' }});
	my $unread = $c->model('ESocial::Message')->search(to_id => $c->user->id, has_read => 0)->count;
	$c->stash(messages => $messages);
	$c->stash(unread => $unread);
	$c->stash(template => 'messages/inbox.tt2');
}

=head2 create_message

Render form for message creation

=cut

sub create_message :Local :Args(1) {
	my ($self, $c, $profile_id) = @_;
	$c->stash(profile_id => $profile_id);
	$c->stash(template => 'messages/create_message.tt2');
}

=head2 send_message

Send message to friend

=cut

sub send_message :Local  :Args(1) {
	my ($self, $c, $profile_id) = @_;
	my $m_title = $c->request->params->{m_title};
	my $m_content = $c->request->params->{m_content} or '';
	if(!$m_content) {
		$c->response->redirect($c->uri_for($c->controller->action_for('create_message'), $profile_id));
		return;
	}
	$c->model('ESocial::Message')->create({
		from_id => $c->user->id,
		to_id => $profile_id,
		title => $m_title,
		content => $m_content
	});
	$c->response->redirect($c->uri_for($c->controller->action_for('message_list'), $c->user->id));
}

=head2 repply

Repply to a message with another

=cut

sub repply :Local :Args(2) {
	my ($self, $c, $profile_id, $msg_id) = @_;
	my $r_title = $c->request->params->{r_title};
	my $r_content = $c->request->params->{r_content};
	if(!$r_content) {
		$c->response->redirect($c->uri_for($c->controller->action_for('view_message'), $msg_id));
		return;
	}
	$c->model('ESocial::Message')->create({
		from_id => $c->user->id,
		to_id => $profile_id,
		title => $r_title,
		content => $r_content
	});
	$c->response->redirect($c->uri_for($c->controller->action_for('message_list'), $c->user->id));
	
}

=head2 view_message

View a message's contents

=cut

sub view_message :Local :Args(1) {
	my ($self, $c, $msg_id) = @_;
	my $message = $c->model('ESocial::Message')->find($msg_id);
	if($message->has_read == 0) {
		$message->has_read(1);
		$message->created($message->created);
		$message->update;
	}
	$c->stash(message => $message);
	$c->stash(template => 'messages/view_message.tt2')
}

=head2 delete_message

Deletes a message by id

=cut

sub delete_message :Local :Args(1) {
	my ($self, $c, $msg_id) = @_;
	my $message = $c->model('ESocial::Message')->find($msg_id);
	$message->delete;
	$c->response->redirect($c->uri_for('message_list'));
}

__PACKAGE__->meta->make_immutable;

1;
