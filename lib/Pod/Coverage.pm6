use v6;

unit class Pod::Coverage;

#|Attribute list for skipping accessor methods
my @currentAttr;

method coverage($toload, $packageStr){
    require ::($toload);
    #start from self
    parse(::($packageStr), "");
}

sub parse($whoO,$level) is export {
    if ($whoO.WHAT ~~ Routine) {
        # Because Routine is a class it must be checked before
        unless $whoO.WHY {
            if $whoO.WHAT ~~ Method {
                
                for @currentAttr -> $attr {
                    if $attr.name.subst(/.\!/, "") ~~ $whoO.name {
                        if $attr.has-accessor {
                            unless $attr.WHY {
                                say $level ~ "\$.{$attr.name}" ~ " is not documented";                             
                            }
                            return
                        }
                    }
                }
            }
            say   $level ~ "::{$whoO.name}  is not documented";
        }  
    }    
    elsif ($whoO.HOW ~~ Metamodel::PackageHOW) {
        for $whoO.WHO.values -> $clazz {
            parse($clazz, $level ~ "::" ~ $whoO.gist); 
        }
    }
    elsif ($whoO.HOW ~~ Metamodel::ModuleHOW) {
        for $whoO.WHO.values -> $clazz {
            if $clazz.^name eq 'EXPORT' {
                for $clazz.WHO<ALL>.WHO.values -> $subr {
                    parse($subr, $level ~ "{$whoO.^name}");
                }

            } else {
                parse($clazz, $level);
            }
            
        }
    } elsif ($whoO.HOW ~~ Metamodel::ClassHOW
             or $whoO.HOW ~~ Metamodel::ParametricRoleGroupHOW) 
    {
        @currentAttr = $whoO.^attributes;
        unless $whoO.WHY {
            say $level ~ "{$whoO.^name} class/role is not documented";
        }
        for $whoO.^methods(:local) -> $m {
            parse($m,$level ~ "{$whoO.^name}");
        }
        for $whoO.WHO<EXPORT>.WHO<ALL>.WHO.values -> $subr {                
            parse($subr,$level ~ "{$whoO.^name}");
        }
        
    }
    else {
        say $level ~ "what is" ~ $whoO.HOW ~ " ?";
    }
}

}

#| Remove after implementing
#sub MAIN(){
#    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
#}

sub MAIN(){
    Pod::Coverage.coverage("Mortgage","Mortgage");
}

#sub MAIN(){
#    Pod::Coverage.coverage("Mortgage","Mortgage");
#}
