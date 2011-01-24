package CWB::CQP::More::Iterator;
use Data::Dumper;
our $VERSION = '0.01';

sub new {
    my ($class, $cwb, $resultset, %ops) = @_;
    return undef unless $resultset && eval { $cwb->isa('CWB::CQP::More') };

    my $self = { name => $resultset, cwb => $cwb };

    $self->{pos}   = 0;
    $self->{crp}   = uc($ops{corpus}) || undef;
    $self->{size}  = $ops{size}       || 1;

    $self->{fname} = $self->{crp}?"$self->{crp}:$self->{name}" : $self->{name};
    $self->{limit} = $cwb->size($self->{fname}) || 0;

    return bless $self => $class;
}

sub reset {
    my $self = shift;
    $self->{pos} = 0;
}

sub increment {
    my $self = shift;
    my $current = $self->{size};
    $self->{size} = shift @_ if $_[0];
    return $current;
}

sub next {
    my ($self) = @_;
    my $cwb = $self->{cwb};
    if ($self->{pos} < $self->{limit}) {
        my @lines = $cwb->cat($self->{fname},
                              $self->{pos} => $self->{pos} + $self->{size} -1);
        $self->{pos} += $self->{size};

        if (scalar(@lines) > 1) {
            return @lines
        } else {
            return wantarray ? @lines : $lines[0];
        }

    } else {
        return undef
    }
}

sub _min { $_[0] < $_[1] ? $_[0] : $_[1] }
sub _max { $_[0] > $_[1] ? $_[0] : $_[1] }


$VERSION;

__END__

=encoding UTF-8

=head1 NAME

CWB::CQP::More::Iterator - Iterator for CWB::CQP resultsets

=head1 SYNOPSIS

  use CWB::CQP::More;

  my $cwb = CWB::CQP::More->new();
  $cwb->change_corpus("foo");
  $cwb->exec('A = "dog";');

  my $iterator = $cwb->iterator("A");
  my $next_line = $iterator->next;

  my $iterator20 = $cwb->iterator("A", size => 20);
  my @twenty = $iterator20->next;

  my $iteratorFoo = $cwb->iterator("A", size => 20, corpus => 'foo');
  my @lines = $iteratorFoo->next;

  $iterator->reset;
  $iterator->increment(20);

=head1 DESCRIPTION

This module implements an interator for CWB result sets. Please to not
use the constructor directly. Instead, use the C<iterator> method on
C<CWB::CQP::More> module.

=head2 C<new>

Creates a new iterator. Used internally by the C<CWB::CQP::More>
module, when the method C<iterator> is called.

=head2 C<next>

Returns the next line(s) on the result set.

=head2 C<reset>

Restarts the iterator.

=head2 C<increment>

Without arguments returns the current iterator increment size (number
of lines returned by iteraction). With an argument, changes the size
of the increment. The increment size can be changed while using the
iterator.

=head1 SEE ALSO

CWB::CQP::More (3), perl(1)

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Alberto Manuel Brandão Simões

=cut
