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
                say $level ~ $whoO.gist ~ " Class";
            } else {
                say $level ~ "what is" ~ $whoO.HOW.gist ~ " ?";
            }
    }

}

sub MAIN(){
    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
}
