{application,sellaprime,
    [{description,"The Prime Number Shop"},
        {vsn,"1.0"},
        {modules,[area_server,lib_primes,lib_lin,prime_server,sellaprime_supervisor,my_alarm_handler]},
        {registered,[area_server,prime_server,sellaprime_supervisor]},
        {applications,[kernel,stdlib]},
        {mod,{sellaprime_app,[]}},
        {start_phases,[]}]
}.