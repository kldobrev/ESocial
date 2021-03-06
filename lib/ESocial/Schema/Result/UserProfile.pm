use utf8;
package ESocial::Schema::Result::UserProfile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ESocial::Schema::Result::UserProfile

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

=head1 TABLE: C<user_profile>

=cut

__PACKAGE__->table("user_profile");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 gender

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 avatar_pic

  data_type: 'text'
  is_nullable: 1

=head2 birthdate

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 show_bdate

  data_type: 'smallint'
  default_value: 0
  is_nullable: 1

=head2 hometown

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 location

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 about

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "gender",
  { data_type => "char", is_nullable => 1, size => 1 },
  "avatar_pic",
  { data_type => "text", is_nullable => 1 },
  "birthdate",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "show_bdate",
  { data_type => "smallint", default_value => 0, is_nullable => 1 },
  "hometown",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "location",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "about",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<ESocial::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "ESocial::Schema::Result::Comment",
  { "foreign.commenter" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 fan_pages

Type: has_many

Related object: L<ESocial::Schema::Result::FanPage>

=cut

__PACKAGE__->has_many(
  "fan_pages",
  "ESocial::Schema::Result::FanPage",
  { "foreign.creator" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friend_group_member_friends

Type: has_many

Related object: L<ESocial::Schema::Result::FriendGroupMember>

=cut

__PACKAGE__->has_many(
  "friend_group_member_friends",
  "ESocial::Schema::Result::FriendGroupMember",
  { "foreign.friend_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friend_group_members

Type: has_many

Related object: L<ESocial::Schema::Result::FriendGroupMember>

=cut

__PACKAGE__->has_many(
  "friend_group_members",
  "ESocial::Schema::Result::FriendGroupMember",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friend_groups

Type: has_many

Related object: L<ESocial::Schema::Result::FriendGroup>

=cut

__PACKAGE__->has_many(
  "friend_groups",
  "ESocial::Schema::Result::FriendGroup",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friend_pair_friends

Type: has_many

Related object: L<ESocial::Schema::Result::FriendPair>

=cut

__PACKAGE__->has_many(
  "friend_pair_friends",
  "ESocial::Schema::Result::FriendPair",
  { "foreign.friend_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friend_pair_users

Type: has_many

Related object: L<ESocial::Schema::Result::FriendPair>

=cut

__PACKAGE__->has_many(
  "friend_pair_users",
  "ESocial::Schema::Result::FriendPair",
  { "foreign.user_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_from

Type: has_many

Related object: L<ESocial::Schema::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages_from",
  "ESocial::Schema::Result::Message",
  { "foreign.from_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_to

Type: has_many

Related object: L<ESocial::Schema::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages_to",
  "ESocial::Schema::Result::Message",
  { "foreign.to_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pages_like

Type: has_many

Related object: L<ESocial::Schema::Result::PageLike>

=cut

__PACKAGE__->has_many(
  "pages_like",
  "ESocial::Schema::Result::PageLike",
  { "foreign.profile_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<ESocial::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "ESocial::Schema::Result::Post",
  { "foreign.author" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<ESocial::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "ESocial::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 wall_posts

Type: has_many

Related object: L<ESocial::Schema::Result::WallPost>

=cut

__PACKAGE__->has_many(
  "wall_posts",
  "ESocial::Schema::Result::WallPost",
  { "foreign.wall_id" => "self.user_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pages

Type: many_to_many

Composing rels: L</pages_like> -> page

=cut

__PACKAGE__->many_to_many("pages", "pages_like", "page");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-24 23:23:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lOWtZ2kjM2IsKPgig1/wXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
