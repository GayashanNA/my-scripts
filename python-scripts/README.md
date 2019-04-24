1. In order to use the `access_twitter_stream.py` script, create a `config.py` file and store your twitter `access_token`, `access_token_secret`, `consumer_key`, and `consumer_secret` in the `config.py` file.

2. If you would like to kill the execution of the script use the following script on a new terminal:
    `kill -9 $(ps aux | grep -v grep | grep "python acc" | awk '{print $2}')`

3. `plot_delay.py` scrit will plot the delay column of a csv file with each row in the format `(system_time, event_time, delay, content...)`