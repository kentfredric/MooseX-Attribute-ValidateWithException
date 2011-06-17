
use strict;
use warnings;

package MooseX::Attribute::ValidateWithException::AttributeRole;
BEGIN {
  $MooseX::Attribute::ValidateWithException::AttributeRole::VERSION = '0.1.0';
}
use Moose::Role;
use Data::Dump qw( dump );
override '_inline_check_constraint' => sub { 
#    my $orig = shift;
    my $self = shift;
    my ( $value, $tc, $tc_obj ) = @_; 
   
    my $attribute_name = quotemeta( $self->name );
    return unless $self->has_type_constraint;

    return ( sprintf q|
       if ( ! %s->( %s ) ) {
          my $message = %s->get_message( %s );
          if( ref $message ){ 
            %s
          } else {
            require MooseX::Attribute::ValidateWithException::Exception;
            %s
          }
       }
    |,
    $tc => $value, 
    $tc_obj => $value,
    $self->_inline_throw_error( $value ), 
    $self->_inline_throw_error( sprintf q| 
        MooseX::Attribute::ValidateWithException::Exception->new(
          attribute_name => '%s',
          data => %s,
          constraint_message => $message,
          constraint => %s,
          constraint_name => %s,
        )
    |,   $attribute_name , $value, $tc_obj, $tc  ),
  );
};


no Moose::Role;

1;

__END__
=pod

=head1 NAME

MooseX::Attribute::ValidateWithException::AttributeRole

=head1 VERSION

version 0.1.0

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric <kentnl@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

