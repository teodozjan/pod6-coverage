use v6;
use Pod::Coverage;
use Test;

unit module Test::Coverage;


#| TAP for Pod::Coverage
sub coverage_ok($metafile) is export {    
    
    my @cases = Pod::Coverage.use-meta($metafile);
    plan @cases.elems;
    for @cases -> $case {
        my $result = $case.are-missing;
        my $what = $case.packageStr ~ " POD coverage";
        if $result {
            $what = $what ~ "\n" ~  $case.get-results.join("\n");
        }
        nok $result, $what;
    } 
    
}

#| same as C<coverage_ok>
sub subtest_coverage_ok($metafile) is export {

    subtest {        
        coverage_ok($metafile);     
    }, "POD coverage";
}


