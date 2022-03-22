# intro
使用`rpm`打包，傳送到centos7

並由`rpm`進行安裝


# 使用rpm進行打包
1. 創作`rpm`要執行的script
```log
├── SRPMS
├── SPECS
├── SOURCES
├── RPMS
├── BUILD
├── BUILDROOT
└── README.md
```

```log
Summary: 
Name:
Version: 1.0
Release: 1
Vendor: vendor
Packager: packager
License: BSD
Group: Applications/File
SOURCE: your_source_be_extraced_at_setup_macro.tar.gz
BuildArch: noarch
BuildRoot: %BuildRoot
```


2. 透過`rpm`進行加工打包
```cli
cd SPECS; rpmbuild -bb example.spec
```


3. build usage
> bash rpm_build_for_files_archive.sh 
```log
Usage> bash rpm_build_for_files_archive.sh SOURCE_DIR RPM_OUTPUT_DIR RPM_PACKAGE_NAME RPM_PACKAGE_VERSION RPM_PACKAGE_VERSION RPM_PACKAGE_INSTALL_DIR SOURCE_GIT_DIR
```


4. touch a file
```bash
mkdir -p /tmp/tester

cat << EOF > /tmp/tester/echo.sh
#!/bin/bash
echo "123"
EOF
```


5. build rpm package
```bash
pid=$$
SOURCE_DIR=$1									# /tmp/tester
OUTPUT_DIR=$2									# /tmp
NAME=$3											# tester
VERSION=$4										# 1.0
RELEASE=$5										# 2.0
INSTALL_DIR=$6									# /tmp
GIT_DIR=$7										# 
DISABLE_BINARY_DEPENDENCY_CHECK=$8				#
PACKAGE_SPEC_FILE=$9							#
RPM_BUILD_WORK_DIR=$HOME/tmp-rpm-build/$pid		#
```
> bash build_rpm.sh /tmp/tester /tmp tester 1.0 2.0 /tmp

```
安裝
$ rpm -ivh your.rpm
解除安裝 
$ rpm -e your_package_name
查詢描述資料
$ rpm -qi your_package_name
列出 rpm 所安裝的檔案清單
$ rpm -q --filesbypkg your_package_name
查詢檔案是屬於哪個 rpm 
$ rpm -qf /opt/path/filename
列出所有已安裝的 rpm 清單，可搭配 grep 挑選關鍵字出來
$ rpm -qa
```


# refer:
- http://blog.changyy.org/2015/11/linux-rpmbuild-rpm-centos-66.html
- https://github.com/changyy/rpm-builder
