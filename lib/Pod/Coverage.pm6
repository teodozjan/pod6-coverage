use v6;

class Pod::Coverage {

    method coverage($toload, $packageStr){
        require ::($toload);
        for ::($packageStr).WHO.values -> $whoO {
            parse($whoO," ");           
        }

    }

    sub parse($whoO,$level){  

      if ($whoO.WHAT ~~ Routine) {            
            unless $whoO.WHY {
                say   $level ~ "{$whoO.gist}  is not documented";
            }  
        }    
        elsif ($whoO.HOW ~~ Metamodel::PackageHOW) {            
            for $whoO.WHO.values -> $clazz {
                parse($clazz, $level); 
            }
        } elsif ($whoO.HOW ~~ Metamodel::ClassHOW
                 or $whoO.HOW ~~ Metamodel::ParametricRoleGroupHOW) 
        {
            unless $whoO.WHY {
                say $level ~ "{$whoO.gist} class/role is not documented";
            }
            for $whoO.^methods(:local) -> $m {
                parse($m,$level ~ "{$whoO.^name}::");
            }
        }
        else {
            say $level ~ "what is" ~ $whoO.HOW ~ " ?";
        }
    }

}

#| Remove after implementing
sub MAIN(){
    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
}

#sub MAIN(){
#    Pod::Coverage.coverage("Pod::Coverage","Pod::Coverage");
#}
