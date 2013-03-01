use utf8;
package ESocial::Schema::Result::PagePost;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ESocial::Schema::Result::PagePost

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

=head1 TABLE: C<page_post>

=cut

__PACKAGE__->table("page_post");

=head1 ACCESSORS

=head2 post_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 page_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "post_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "page_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_id>

=back

=cut

__PACKAGE__->set_primary_key("post_id");

=head1 RELATIONS

=head2 page

Type: belongs_to

Related object: L<ESocial::Schema::Result::FanPage>

=cut

__PACKAGE__->belongs_to(
  "page",
  "ESocial::Schema::Result::FanPage",
  { id => "page_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-28 22:51:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rz1YFDHQaHQdRJjwJwEUew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
