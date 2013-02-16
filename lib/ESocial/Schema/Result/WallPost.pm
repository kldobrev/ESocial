use utf8;
package ESocial::Schema::Result::WallPost;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ESocial::Schema::Result::WallPost

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<wall_post>

=cut

__PACKAGE__->table("wall_post");

=head1 ACCESSORS

=head2 post_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 wall_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 privacy_lev

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "post_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "wall_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "privacy_lev",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_id>

=back

=cut

__PACKAGE__->set_primary_key("post_id");

=head1 RELATIONS

=head2 post

Type: belongs_to

Related object: L<ESocial::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post",
  "ESocial::Schema::Result::Post",
  { id => "post_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 wall

Type: belongs_to

Related object: L<ESocial::Schema::Result::UserProfile>

=cut

__PACKAGE__->belongs_to(
  "wall",
  "ESocial::Schema::Result::UserProfile",
  { user_id => "wall_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-16 13:22:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Cwk+VAVaEr+Tgy48UUvtDw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
