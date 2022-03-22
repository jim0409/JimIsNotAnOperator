# intro
### install java
yum install -y java-1.8.0-openjdk-devel

### install jenkins jar file for process
### import the GPG key
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo

### add jeknins to yum repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

### install jenkins with `yum`
yum install -y jenkins

### setup jenkins systemctl
systemctl start jenkins

### check jenkins status
systemctl status jenkins

### if there is a auto restart needed ... enable systemctl
systemctl enable jenkins


# refer:
- https://linuxize.com/post/how-to-install-jenkins-on-centos-7/