# intro
在 ubuntu 20.04 上安裝 Jenkins

# steps
1. add jenkins key
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
2. add jenkins repo
```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
```
3. install jenkins
```
sudo apt-get update
sudo apt-get install jenkins
```


# refer:
- https://www.jenkins.io/doc/book/installing/linux/