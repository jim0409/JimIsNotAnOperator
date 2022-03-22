# 錯誤
```log
Last login: Sat Sep  8 03:38:54 2018 from 223.104.145.191
-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
```

# 修正方法
```log
vim /etc/environment

add these lines...

LANG=en_US.utf-8
LC_ALL=en_US.utf-8
```


# refer:
centos7
- https://www.jianshu.com/p/7f2ccb2e9425
ubuntu
- https://gist.github.com/SimonSun1988/2ef7db45e46b889783647d941ec15e4d