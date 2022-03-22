# intro
1. use nginx as the CDN
2. use varnish as http Accelerator
3. use nginx as the Loadbalance
4. use redis as service cache
5. with golang httpServer return DateAPI{yyy/mm/dd/hh/mm}


# architecture
```
        client
          |
         CDN
          |
    HttpAccelerator
          |
      LoadBalance
          |
        Redis
          |
        Service
```


