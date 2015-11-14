use v6;
use Pod::To::Text;
class Pod::To::Keywords {
    method render(@pod) {
        for @pod -> $pode { # different pods
            for $pode.contents -> $v {
                if $v ~~ Pod::Heading {
                    say Pod::To::Text.render( $v );

                }
            }
            
            
        }

    }
}





