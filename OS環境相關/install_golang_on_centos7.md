# install Go on centos7
wget https://golang.org/dl/go1.17.linux-amd64.tar.gz
sudo tar -xvf go1.17.linux-amd64.tar.gz

sudo mv go /usr/local

# Setup Go Env
# All the environment will be set for your current session only. To make it permanent add in ~/.profile file.
export GOPATH=/root/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Verify Installation
go version
go env

# 後記
- 如何更新golang版本?
1. 刪除/usr/local/go
2. 重新下載新的targ
3. 將新下載好的 `go` 資料夾移動到 `/usr/local`

# refer:
- https://golang.org/dl/