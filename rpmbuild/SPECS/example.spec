%define Name test-repo
%define Source test-repo.tar.gz
%define Version 1.0
%define Release 1
%define RPM_ARCH x64_86
%define OWNER root
%define Vendor no
%define Packager no
%define License MIT
%define Group Applications/File

%define INSTALL_DIR /opt/%NAME

%define _topdir /tmp/rpm-build
%define RPM_BUILD_ROOT _topdir
%define BuildRoot /tmp/rpm-build/BUILDROOT/%Name-%Version-%Release.%RPM_ARCH

Summary: %Name
Name: %Name
Version: %Version
Release: %Release
Vendor: %Vendor
Packager: %Packager
License: %License
Group: %Group
SOURCE: %Source

%description

%prep

%setup -q

%build

%install
install -d %BuildRoot/%INSTALL_DIR
cp -r $PACKAGE_DIR/*.* %BuildRoot/%INSTALL_DIR

%files
%INSTALL_DIR
%defattr(-,%OWNER,%OWNER,-)

%changelog
