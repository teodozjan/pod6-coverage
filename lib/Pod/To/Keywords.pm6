use v6;
use Pod::To::Text;

#| Strips I<keywords> that indicate documented methods/classes/subs etc.
class Pod::To::Keywords {
    method render(@pod) {
        for @pod -> $pode { #= different pods
            for $pode.contents -> $v {
                if $v ~~ Pod::Heading {
                    say Pod::To::Text.render( $v );

                }
            }
            
            
        }

    }
}





