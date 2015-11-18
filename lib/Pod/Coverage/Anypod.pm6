use v6;
use Pod::Tester;

#| Sometimes any block pod no matter what contains may be fine 
unit class Pod::Coverage::Anypod does Pod::Tester;

has $.path;
has $.packageStr;

method check {

    self!file-haspod;
    
}
#| Checks if module file contains at least any line of pod
method !file-haspod {    
    my $haspod =  qqx/$*EXECUTABLE-NAME --doc $!path/.lines;
    unless $haspod.elems > 0 {
        my $expod = $!path.subst(/\.pm[6]*$/, '.pod');    
        my $extpod = qqx/$*EXECUTABLE-NAME --doc $expod/.lines;
        
        @!results.push($!packageStr) unless $extpod.elems>0;
    }
}

#| Returns stringified version of results... in opposite to
#| raw C<@.results>
method get-results {
    gather {
        if @!results {   
            for @!results.values -> $result {            
                take $result.^name ~ " has no pod";
            }            
        } else {
            take $!packageStr ~ " has pod";
        }
    }

}
