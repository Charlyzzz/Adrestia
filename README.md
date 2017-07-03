# Adrestia

## Run
In order to test with big loads, increase open file limits.

Open file: `/etc/security/limits.conf` and paste following towards end:
~~~bash
*         hard    nofile      500000
*         soft    nofile      500000
root      hard    nofile      500000
root      soft    nofile      500000
~~~

Once you save file, you may need to logout and login again.

Download all dependences with `mix deps.get`.

Spin up as many dummy servers as you like with `ruby test_server -p $PORT` and then add them to your `config.exs` file.

Upon configuring all up (via _config.exs_), run `mix adrestia.balance`.

##Actors

A Plug-based Cowboy server handles all new connections, using `Endpoint` as a plug, which interacts with `Balancer`, asking for a server address to derive the request. 

The main pipeline can be seen in `Endpoint`, line 18. The cacheability is determined upon entering the pipeline, which can skin cache related steps if neccesary. If there are no available servers, the request skips the pipeline and is dispatched with `service_unavailable` to the sender.

Every `active_check_time` all endpoints are queried with a `HEAD` request, and reported it's status to `Balancer`. Also the results are printed.`
`ActiveCheck` is not an Actor and is handled by Erlang's `:timer` library.


`Cowboy` <-- call --> `Endpoint` <-- server_address --> `Balancer` <-- server_up / server-down--> `ActiveCheck`