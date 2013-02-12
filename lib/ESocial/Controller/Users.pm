package ESocial::Controller::Users;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ESocial::Controller::Users - Catalyst Controller

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

=head2

Validate user input

=cut

sub valid_message {
	my $params = shift;
	if(length($params->{reg_name}) < 3) {
		return "Name must be at least 3 characters long.";
	}
	if(length($params->{reg_pass}) < 8) {
		return "Password must be at least 8 characters long."
	}
	if($params->{reg_pass} ne $params->{reg_rep_pass}) {
		return "The repeated password does not match the password you entered before that.";
	}
	if(!($params->{reg_email} =~ /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}/)) {
		return "The email address you have entered is not valid";
	}
	return "";
}

=head2 register

Create a new user and profile record in the database

=cut

sub register :Path('/register') {
	my ($self, $c) = @_;
	my $validation_error = valid_message($c->request->params);
	if($validation_error ne "") {
		$c->stash(error_register_msg => $validation_error);
		$c->stash(template => 'index.tt2');
		return;
	}
	my $name = $c->request->params->{reg_name};
	my $email = $c->request->params->{reg_email};
	my $password = $c->request->params->{reg_pass};
	my $rep_password = $c->request->params->{reg_rep_pass};
	my $user = $c->model('ESocial::User')->create({
		email => $email,
		password => $password,
	});
	$user->create_related('user_profile', {name => $name});
	$c->stash(reg_success_msg => "You have successfuly registered. Now you can login to view your profile:");
	$c->stash(template => 'index.tt2');
}

=head2 login

Login for registered users

=cut

sub login :Path('/login') {
	my ($self, $c) = @_;
	my $email = $c->request->params->{log_email};
	my $password = $c->request->params->{log_pass};
	if($c->authenticate({email => $email, password => $password})) {
		$c->response->redirect($c->uri_for($c->controller('Profile')->action_for("get_profile"), $c->user->id));
		return 1;
	}
	else {
		$c->stash(error_login_msg => 'Wrong email or password.');
		$c->stash(template => 'index.tt2');
	}
}

=head2 logout

Logout current user

=cut

sub logout :Path('/logout') {
	my ($self, $c) = @_;
	$c->logout;
	$c->response->redirect($c->uri_for('/'));
}

__PACKAGE__->meta->make_immutable;

1;
