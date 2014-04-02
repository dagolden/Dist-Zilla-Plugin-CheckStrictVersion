use 5.008001;
use strict;
use warnings;

package Dist::Zilla::Plugin::CheckStrictVersion;
# ABSTRACT: BeforeRelease plugin to check for a strict version number
# VERSION

use Moose 2;
use version ();

with 'Dist::Zilla::Role::BeforeRelease';

=attr decimal_only

If true, only a decimal (non-tuple) version is allowed.  Default is false.

=cut

has decimal_only => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

=attr tuple_only

If true, only a tuple (a.k.a. 'dotted-decimal') version is allowed.  Default is
false.

=cut

has tuple_only => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

# methods

sub before_release {
    my $self = shift;
    my $ver  = $self->zilla->version;

    $ver = version->parse($ver);

    $self->log_fatal("version $ver fails version::is_strict")
      unless version::is_strict("$ver");

    if ( $self->decimal_only ) {
        $self->log_fatal("version $ver is not a decimal type version")
          if $ver->is_qv;
    }

    if ( $self->tuple_only ) {
        $self->log_fatal("version $ver is not a tuple type version")
          unless $ver->is_qv;
    }

    return;
}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

In your F<dist.ini> file:

    [CheckStrictVersion]
    decimal_only = 1

=head1 DESCRIPTION

This module enforces strict versions, with optional enforcement of 'decimal' or 'tuple'
(a.k.a 'dotted decimal') forms.

=head1 SEE ALSO

=for :list
* L<Version numbers should be boring|http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/>

=cut

# vim: ts=4 sts=4 sw=4 et:
