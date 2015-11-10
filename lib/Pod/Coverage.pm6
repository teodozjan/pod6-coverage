use v6;

class Pod::Coverage {

    method coverage($toload, $packageStr){
        require ::($toload);
        for ::($packageStr).WHO.values -> $whoO {
            say $whoO;
        }

    }


}

sub MAIN(){
    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
}
