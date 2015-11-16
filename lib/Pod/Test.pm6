use v6;

use Pod::Coverage;

class Pod::Test {
    has $.object;
    has $.pod_file;
    

    method what () {
        my $n = Pod::Coverage.coverage;
        


    }

}
