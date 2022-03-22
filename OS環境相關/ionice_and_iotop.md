# intro
在壓測時，使用iotop可以觀察是否有`io`上的瓶頸。透過學習`iotop`更進一步暸解程序運作原理。


# installation
> yum install -y iotop

# <intro: iotop> 
1. iotop: 直接看每一隻執行緒`當下的`io
2. iotop -a: 看每一隻執行緒`累積的`io
3. iotop -p $pid: 觀看`某一隻`執行緒的io


# <intro: ionice>
ionice命令可以獲取和設置一個程序的I/O調度類型和優先級

### idle

### Best effort

### Real time


### parameter
- `-c`: class，指定調度類型，0代表none，1代表`real time`，2代表`best effort`，3代表`idle`
- `-n`: classdata，指定優先級`real time`和`best effor`可以使用0-7
- `-p`: pid，察看或改變已經運行的進程的調度類型和優先級
- `-t`: 忽略設置指定優先級的錯誤信息

### example
1. 設置`PID為18944`的進程`I/O`調度類型為idle
> sudo ionice -c3 -p18944
2. 查看`PID為18944`的進程的`I/O`調度類型和優先級idle
> sudo ionice -p 18944
3. 以best effort的最高優先級運行bash程序
> sudo ionice -c2 -n0 bash hello.sh
```bash
#!/bin/bash
echo "hello"
```

# refer:

### iotop
- https://www.arthurtoday.com/2013/03/iotop-tutorial.html

### ionice
- https://blog.51cto.com/john88wang/1553812

### iostat
- https://www.itread01.com/content/1549215738.html
