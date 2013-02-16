use utf8;
package ESocial::Schema::Result::DataPage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ESocial::Schema::Result::DataPage

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

=head1 TABLE: C<data_page>

=cut

__PACKAGE__->table("data_page");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 creator

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 about

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "creator",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "about",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 creator

Type: belongs_to

Related object: L<ESocial::Schema::Result::UserProfile>

=cut

__PACKAGE__->belongs_to(
  "creator",
  "ESocial::Schema::Result::UserProfile",
  { user_id => "creator" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 pages_like

Type: has_many

Related object: L<ESocial::Schema::Result::PageLike>

=cut

__PACKAGE__->has_many(
  "pages_like",
  "ESocial::Schema::Result::PageLike",
  { "foreign.page_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 profiles

Type: many_to_many

Composing rels: L</pages_like> -> profile

=cut

__PACKAGE__->many_to_many("profiles", "pages_like", "profile");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-02-16 23:15:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8eFIOrrOnqDz1p3beXwdaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
