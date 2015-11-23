use v6;
use Pod::To::Text;
use Pod::Coverage::Result;


# Strips I<keywords> that indicate documented methods/classes/subs etc.
class Pod::To::Keywords {
    has Pod::Coverage::Result $.results = ();
    
    method render(@pod) {
        for @pod -> $pode {
            for $pode.contents -> $v {
                if $v ~~ Pod::Heading  {
                    
                }

                # TODO check header METHODS
                if $v ~~ Pod::Item {
                    say "routine " ~ Pod::To::Text.render( $v.contents );
                }
            }
            
            
        }

    }
}

=begin pod

=NAME Pod::To::Coverage

=SYNOPSIS perl6 --doc=Keywords

=begin DESCRIPTION

Here lies description like C<dump-results()>

=end DESCRIPTION

=METHOD render

Render description

=end pod

