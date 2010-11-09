package CWB::CQP::More;

use base CWB::CQP;
use CWB;

use Try::Tiny;

use warnings;
use strict;

=head1 NAME

CWB::CQP::More - A higher level interface for CWB::CQP

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use CWB::CQP::More;

    my $cqp = CWB::CQP::More->new();

    $cqp->change_corpus('HANSARDS');

    # This needs to get fixed... not nice to say "'<b>'"
    $cqp->set(Context  => [20, 'words'],
              LD       => "'<b>'",
              RT       => "'</b>'");

    # using Try::Tiny...
    try {
        $cqp->exec('A = "dog"; cat A');
    } catch {
        print "Error: $_\n";
    }

    $details = $cqp->corpora_details('hansards');

    $available_corpora = $cqp->show_corpora;


=head1 METHODS

This class superclasses CWB::CQP and adds some higher-order
functionalities.

=head2 new

The C<new> constructor has the same behavior has the C<CWB::CQP>
C<new> method.

=cut

sub new {
    my ($class, @args) = @_;
    my $self = $class->SUPER::new(@args);
    $self->set_error_handler( sub {} );
    bless $self => $class;
    return $self;
}

=head2 annotation_show

Use this method to specify what annotations to make CQP to show. Pass
it a list of the annotation names.

=cut

sub annotation_show($@) {
    my ($self, @annotations) = @_;
    my $annots = join(" ", map { "+$_" } @annotations);
    $self->exec("show $annots;");
}

=head2 annotation_hide

Use this method to specify what annotations to make CQP to not show
(hide). Pass it a list of the annotation names.

=cut

sub annotation_hide($@) {
    my ($self, @annotations) = @_;
    my $annots = join(" ", map { "-$_" } @annotations);
    $self->exec("show $annots;");
}

=head2 change_corpus

Change current active corpus. Pass the corpus name as the argument.

=cut

sub change_corpus($$) {
    my ($self, $cname) = @_;
    $cname = uc $cname;
    $self->exec("$cname;");
}

=head2 set

Set CQP properties. Pass a hash (not a reference) of key/values to be
set. Note that at the moment string values should be double quoted
(see example in the synopsis).

=cut

sub set($%) {
    my ($self, %vars) = @_;
    for my $key (keys %vars) {
        my $values;
        if (ref($vars{$key}) eq "ARRAY") {
            $values = join(" ", @{$vars{$key}});
        } else {
            $values = $vars{$key};
        }

        try {
            $self->exec("set $key $values;");
        };
    }
}

=head2 exec

Similar to CWB::CQP->exec, but dying in case of error with the error
message. Useful for use with C<Try::Tiny>. Check the synopsis above
for an example.

=cut

sub exec {
    my ($self, @args) = @_;
    my @answer = $self->SUPER::exec(@args);
    die $self->error_message unless $self->ok;
    return @answer;
}

=head2 corpora_details

Returns a reference to a hash with details about a specific corpus,
like name, id, home directory, properties and attributes;

=cut

sub corpora_details {
    my ($self, $cname) = @_;
    return undef unless $cname;

    $cname = lc $cname unless $cname =~ /(?:\/|\\)/;

    my $details = {};
    my $reg = new CWB::RegistryFile $cname;
    return undef unless $reg;

    $details->{filename}  = $reg->filename;
    $details->{name}      = $reg->name;
    $details->{corpus_id} = $reg->id;
    $details->{home_dir}  = $reg->home;
    $details->{info_file} = $reg->info;

    my @properties = $reg->list_properties;
    for my $property (@properties) {
        $details->{property}{$property} = $reg->property($property);
    }

    my @attributes = $reg->list_attributes;
    for my $attr (@attributes) {
        $details->{attribute}{$reg->attribute($attr)}{$attr} = $reg->attribute_path($attr);
    }

    return $details;
}

=head2 show_corpora

Returns a reference to a list of the available corpora;

=cut

sub show_corpora {
    my $self = shift;
    my $ans;
    try {
        $ans = [ $self->exec("show corpora;") ];
    } catch {
        $ans = [];
    };
    return $ans;
}


=head1 AUTHOR

Alberto Simoes, C<< <ambs at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-cwb-cqp-more at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CWB-CQP-More>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CWB::CQP::More


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CWB-CQP-More>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CWB-CQP-More>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CWB-CQP-More>

=item * Search CPAN

L<http://search.cpan.org/dist/CWB-CQP-More/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Alberto Simoes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of CWB::CQP::More
