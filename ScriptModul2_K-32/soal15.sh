> in elrond
apt update
apt install -y apache2-utils

ab -n 500 -c 10 http://www.K32.com/app/

ab -n 500 -c 10 http://www.K32.com/static/

```
root@Elrond:~# ab -n 500 -c 10 http://www.K32.com/app/
This is ApacheBench, Version 2.3 <$Revision: 1923142 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.K32.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Finished 500 requests


Server Software:        nginx
Server Hostname:        www.K32.com
Server Port:            80

Document Path:          /app/
Document Length:        273 bytes

Concurrency Level:      10
Time taken for tests:   0.139 seconds
Complete requests:      500
Failed requests:        0
Non-2xx responses:      500
Total transferred:      218000 bytes
HTML transferred:       136500 bytes
Requests per second:    3588.19 [#/sec] (mean)
Time per request:       2.787 [ms] (mean)
Time per request:       0.279 [ms] (mean, across all concurrent requests)
Transfer rate:          1527.78 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.2      1       2
Processing:     1    2   0.7      2       7
Waiting:        1    2   0.7      2       7
Total:          2    3   0.8      3       8

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      3
  80%      3
  90%      3
  95%      4
  98%      5
  99%      7
 100%      8 (longest request)
```

root@Elrond:~# ab -n 500 -c 10 http://www.K32.com/static/
This is ApacheBench, Version 2.3 <$Revision: 1923142 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.K32.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Finished 500 requests


Server Software:        nginx
Server Hostname:        www.K32.com
Server Port:            80

Document Path:          /static/
Document Length:        273 bytes

Concurrency Level:      10
Time taken for tests:   0.114 seconds
Complete requests:      500
Failed requests:        0
Non-2xx responses:      500
Total transferred:      218000 bytes
HTML transferred:       136500 bytes
Requests per second:    4389.58 [#/sec] (mean)
Time per request:       2.278 [ms] (mean)
Time per request:       0.228 [ms] (mean, across all concurrent requests)
Transfer rate:          1869.00 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.3      1       2
Processing:     1    2   0.6      1       5
Waiting:        1    2   0.6      1       5
Total:          1    2   0.8      2       6
WARNING: The median and mean for the processing time are not within a normal deviation
        These results are probably not that reliable.
WARNING: The median and mean for the waiting time are not within a normal deviation
        These results are probably not that reliable.

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      4
  98%      5
  99%      6
 100%      6 (longest request)
```