use v6;

class Pod::Coverage {

    method coverage($toload, $packageStr){
        require ::($toload);
        for ::($packageStr).WHO.values -> $whoO {
            parse($whoO," ");           
        }

    }

    sub parse($whoO,$level){
        if ($whoO.HOW ~~ Metamodel::PackageHOW) {
            say $level ~ $whoO.gist ~ " Package";
            say parse($whoO.WHO.values," " ~ $level); 
        } elsif ($whoO.HOW ~~ Metamodel::ClassHOW) {
            unless $whoO.WHY {
                say $level ~ $whoO.gist ~ " class is not documented";
            }
            } else {
                say $level ~ "what is" ~ $whoO.HOW.gist ~ " ?";
            }
    }

}

#| Remove after implementing
sub MAIN(){
    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
}
