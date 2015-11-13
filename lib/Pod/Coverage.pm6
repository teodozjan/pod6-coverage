use v6;

class Pod::Coverage {

    #|Attribute list for skipping accessor methods
    has @!currentAttr;
    has @!results;

    method coverage($toload, $packageStr){
        require ::($toload);
        #start from self
        my $i = Pod::Coverage.new;
        $i.parse(::($packageStr));
        $i.show-results;
    }

    method show-results {
         for @!results.values -> $result {
            if $result.^can("package") {
                 say $result.package.^name ~ "::" ~ $result.name ~ " is not documented";
            }
            else {
                say $result.^name ~ " is not documented";
            }
         }

      }

    method parse($whoO) {
        if ($whoO.WHAT ~~ Routine) {
            # Because Routine is a class it must be checked before
            unless $whoO.WHY {
                if $whoO.WHAT ~~ Method {
                    
                    for @!currentAttr -> $attr {
                        if $attr.name.subst(/.\!/, "") ~~ $whoO.name {
                            
                            if $attr.has-accessor {
                                unless $attr.WHY {
                                    @!results.push: $attr;
                                }
                                return
                            }
                        }
                    }
                }
                @!results.push: $whoO;
            }  
        }    
        elsif ($whoO.HOW ~~ Metamodel::PackageHOW) {
            for $whoO.WHO.values -> $clazz {
                self.parse($clazz); 
            }
        }
        elsif ($whoO.HOW ~~ Metamodel::ModuleHOW) {
            for $whoO.WHO.values -> $clazz {
                if $clazz.^name eq 'EXPORT' {
                    for $clazz.WHO<ALL>.WHO.values -> $subr {
                        self.parse($subr);
                    }

                } else {
                    self.parse($clazz);
                }
                
            }
        } elsif ($whoO.HOW ~~ Metamodel::ClassHOW ) 
        {
            unless $whoO.WHY {
                @!results.push: $whoO;
            }
      
            @!currentAttr = $whoO.^attributes;
      
            for $whoO.^methods(:local) -> $m {                
                self.parse($m);
            }
      
            @!currentAttr = ();
            
            for $whoO.WHO<EXPORT>.WHO<ALL>.WHO.values -> $subr {   
                self.parse($subr);
            }
             
        }
        elsif ($whoO.HOW ~~ Metamodel::ParametricRoleGroupHOW) {
            for $whoO.^candidates -> $role {
                self.parse($role);
            }
        }
#        elsif ($whoO ~~ Grepper)
#        {
            #todo

#        }
        else {
            warn "What is " ~ $whoO.^name ~ " ?";
        }
    }

}
#| Remove after implementing
#sub MAIN(){
#    Pod::Coverage.coverage("LacunaCookbuk::Client","LacunaCookbuk");
#}

#sub MAIN(){
#    Pod::Coverage.coverage("Mortgage","Mortgage");
#}

#sub MAIN() {
#    Pod::Coverage.coverage("File::Find","Pod::Coverage");
#}

sub MAIN() {
    Pod::Coverage.coverage("File::Find","File::Find");
}
