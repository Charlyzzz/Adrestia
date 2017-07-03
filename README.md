# Adrestia

## Run
In order to test with big loads, increase open file limits.
Open file: `/etc/security/limits.conf`

Paste following towards end:
~~~bash
*         hard    nofile      500000
*         soft    nofile      500000
root      hard    nofile      500000
root      soft    nofile      500000
~~~

Once you save file, you may need to logout and login again.

Download all dependences with `mix deps.get`.
Spin up as many dummy servers as you like with `ruby test_server -p $PORT` and then add them to your `config.exs` file
Upon configuring all up (via _config.exs_), run `mix adrestia.balance`.
