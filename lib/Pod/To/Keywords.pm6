use v6;
use Pod::To::Text;

#| Strips I<keywords> that indicate documented methods/classes/subs etc.
class Pod::To::Keywords {
    method render(@pod) { #= Go though different pods
        for @pod -> $pode {
            for $pode.contents -> $v {
                if $v ~~ Pod::Heading {
                    say Pod::To::Text.render( $v );

                }
            }
            
            
        }

    }
}





