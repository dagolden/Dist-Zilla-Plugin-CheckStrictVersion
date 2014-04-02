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

=for Pod::Coverage before_release

=head1 SYNOPSIS

In your F<dist.ini> file:

    [CheckStrictVersion]
    decimal_only = 1

=head1 DESCRIPTION

This module enforces strict versions, with optional enforcement of 'decimal' or 'tuple'
(a.k.a 'dotted decimal') forms.

As a reminder, here are the rules for strict versions from L<version::Internals>:

    v1.234.5
        For dotted-decimal versions, a leading 'v' is required, with three
        or more sub-versions of no more than three digits. A leading 0
        (zero) before the first sub-version (in the above example, '1') is
        also prohibited.

    2.3456
        For decimal versions, an integer portion (no leading 0), a decimal
        point, and one or more digits to the right of the decimal are all
        required.

=head1 SEE ALSO

=for :list
* L<Version numbers should be boring|http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/>

=cut

# vim: ts=4 sts=4 sw=4 et:
