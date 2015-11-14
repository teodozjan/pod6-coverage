use v6;
use JSON::Fast;



class Pod::Coverage {

    #|Attribute list for skipping accessor methods
    has @!currentAttr;
    has @!results;

    method use-meta($metafile){
        my $mod = from-json slurp $metafile;
        for (flat @($mod<provides>//Empty)) -> $val {
            for $val.kv -> $k, $v {
                Pod::Coverage.coverage($k,$k, $v);
            }
        }
    }

    
    method coverage($toload, $packageStr, $path){
        require ::($toload);
        #start from self
        my $i = Pod::Coverage.new;
        $i.parse(::($packageStr));
        $i.correct-pod($path);
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

    method correct-pod($filename) {
        my @keywords = qqx/$*EXECUTABLE-NAME --doc=Keywords $filename/.lines;
        dd @keywords;
        my $a = "coverage";
        say @keywords.first(/method\S+$<a>/);
        my @new_results;
        for @!results -> $result {
            # HACK
            my $name = $result.can("package") ?? $result.name !! $result.^name;
            if $result.WHAT ~~ Sub {  
                @new_results.push: $result unless @keywords.first(/[sub|routine|subroutine] $name/);                
            } elsif $result.WHAT ~~ Routine {
                @new_results.push: $result unless @keywords.first(/[method] $name/); 
            } else {
                @new_results.push: $result unless @keywords.first(/$name/); 
            }
        }
        dd @new_results;
        
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

#sub MAIN() {
#    Pod::Coverage.use-meta("/home/kamil/mortage6/META.info");
#}

sub MAIN() {
    Pod::Coverage.use-meta("/home/kamil/pod6-coverage/META.info");
}



=begin pod

    =head1 Pod::Coverage

    =head2 method C<coverage>

    banana banana

=end pod
