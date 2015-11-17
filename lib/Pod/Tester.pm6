use v6;

role Pod::Tester {
    has @.results = ();
    #| true if any pod is missing
    method are-missing {
        @!results.Bool;
    }

    #| do all need
    method check {!!!}

    #| override if want custom results
    method get-results {@!results}

}
