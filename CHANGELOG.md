##2014-XX-YY - Release 2.1.0
###Summary

* Documentation of the `duplicity` class has been reviewed
* Better separation of the configuration properties when using the package vs archive type
* Duply archive is downloaded from sourceforge instead some dude's dropbox account
* Using the archive no longer requires to specify `duply_package_name` or `duply_archive_url`; setting the version and
  checksum is enough
* Add support for Ubuntu 12.04 and 14.04
* Add support for RHEL/CentOS 6
* Add system tests

##2014-12-25 - Release 2.0.0
###Summary

* Add default package name/version/handler for Debian based distributions
* Replace gini/archive with camptocamp/archive
* Fix broken example in README
