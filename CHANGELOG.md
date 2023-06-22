# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [6.6.3](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.6.3) (2023-06-22)
                                                                                  
### Updated

- Duply from 2.4.1 to 2.4.3 ([changelog](http://duply.net/Changelog-TODO))

## [6.6.2](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.6.2) (2023-06-19)

### Updated

- Removed Puppet 5 from test matrix
- Puppet module dependencies; this module works fine with the 9.x versions of concat and stdlibs, yet the 
  puppet-logrotate module only supports stdlib up to 8.x  

## [6.6.1](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.6.1) (2022-12-28)

### Improved

- Fix deprecation warnings raised by Puppet

## [6.6.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.6.0) (2022-12-26)

### Added

- Support for Debian 11 and Ubuntu 22.04  

### Updated

- Duply 2.2.2 (2020-02-24) -> 2.4.1 (2022-09-09)
- Puppet module dependencies

## [6.5.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.5.0) (2021-03-13)

### Improved

- Compatibility with Debian 11 Bullseye ([#76](https://github.com/tohuwabohu/puppet-duplicity/pull/76))

## [6.4.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.4.0) (2021-02-28)

### Added

- Mark logrotate 5.x as supported

## [6.3.1](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.3.1) (2021-02-13)
  
### Added

- Support for Puppet 7
            
### Changed

- Replace Ubuntu 16.04 with Ubuntu 20.04 in acceptance test matrix

## [6.3.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.3.0) (2021-02-06)
                                                                                  
### Added

- Allow forwarding duply logs to logger command ([#68](https://github.com/tohuwabohu/puppet-duplicity/pull/68))

### Changed
                
- Fix broken example in README.md ([#67](https://github.com/tohuwabohu/puppet-duplicity/issues/67))
- Migrate from travis-ci.org to Github Actions due to pending shutdown :sob:

## [6.2.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.2.0) (2020-08-04)

### Added

- Allow arrays as valid input for `$cron_hour` ([#61](https://github.com/tohuwabohu/puppet-duplicity/pull/61))

## [6.1.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.1.0) (2020-04-12)

### Changed

- Replace deprecated `is_` and `validate_` puppetlabs/stdlib functions with Puppet data types

### Deprecated

- `profile::max_full_backups` and `profile::max_fulls_with_incrs` currently accept values of type `String` and `Integer`
  as long as they look like a number. Support for `String` will be removed in the next major release.

## [6.0.0](https://github.com/tohuwabohu/puppet-duplicity/tree/v6.0.0) (2020-03-14)

### Added

- Support for Debian 10 and Ubuntu 18.04  
 
### Changed

- Update Puppet modules to their latest major version, in particular concat and stdlib are now on 6.x. As a result,
  Puppet 4.x has officially been dropped
- Update `$duply_archive_version` from 1.9.1 to 2.2.2
- Update acceptance tests from Puppet 5 to Puppet 6

### Deprecated 

- `$duply_version` has been deprecated, it was only need to distinguish if the version of duply is older than 1.7.1 

### Removed

- Official support for Puppet 4 (it should still work though)
- Duply older than 1.7.1 will no longer be supported. As a result the parameter `$duply_version` became redundant
- Support for Debian 8 and Ubuntu 12.04  
 
## [5.1.1] - 2020-03-14
### Changed

- Update Puppet modules to their latest minor version
 
## [5.1.0] - 2019-06-18
### Changed

- Add Debian 10 and defaults ([#57](https://github.com/tohuwabohu/puppet-duplicity/pull/57))

## [5.0.0] - 2018-09-23
### Changed

- Replacement of [yo61/logrotate](https://forge.puppet.com/yo61/logrotate) with 
  [puppet/logrotate](https://forge.puppet.com/puppet/logrotate); this requires at least version 4.22 of 
  [puppetlabs/stdlib](https://forge.puppet.com/puppetlabs/stdlib) but other than that is a plain drop-in replacement.
- Replacement of [camptocamp/archive](https://forge.puppet.com/camptocamp/archive) with 
  [puppet/archive](https://forge.puppet.com/puppet/archive). A minor change in behaviour is that the package is no 
  longer cached on the server but instead deleted after the extraction was successful.
- Renamed `duply_archive_md5sum` to `duply_archive_checksum`. Note: the default checksum type is now `sha1`. 
- Update the default of `duply_archive_version` from 1.7.3 to 1.9.1; this is a conservative update: if it is safe to 
  upgrade the default to a more recent version please raise a pull request.

### Added 
- Parameter `duply_archive_checksum_type` which can be used to specify a different checksum type when using the archive
  provider. The default is `sha1`.
- Support for [Puppet 6](https://puppet.com/blog/introducing-puppet-6). Note: this will require to add the 
  [puppetlabs/cron_core](https://forge.puppetlabs.com/puppetlabs/cron_core) module as the `cron` resource is no longer
  provided by Puppet itself.
  
### Removed
- Parameter `duply_archive_package_dir` is no longer required as the downloaded duply archives are now deleted after
  extraction
- Deprecated parameter `duply_executable`

## 2018-09-19 - Release 4.10.1

Improve compatibility with Puppet 5 by supporting concat up to 5.x.

## 2017-12-17 - Release 4.10.0

Add parameter for `TEMP_DIR` ([#43](https://github.com/tohuwabohu/puppet-duplicity/pull/43)).

## 2017-08-19 - Release 4.9.0

Add an extra `duply_extra_packages` parameter used to install additional packages required by various storage backends
([#49](https://github.com/tohuwabohu/puppet-duplicity/pull/49)).

## 2017-08-13 - Release 4.8.0

This release contains a number of minor improvements.

* Helper class to be able to create profiles through Foreman ([#46](https://github.com/tohuwabohu/puppet-duplicity/pull/46))
* Remove the check for S3 keys as it doesn't work well with AWS instance profiles ([#48](https://github.com/tohuwabohu/puppet-duplicity/issues/48), [#50](https://github.com/tohuwabohu/puppet-duplicity/pull/50))
* Add profile parameter to specifiy include/exclude in verbatim ([#51](https://github.com/tohuwabohu/puppet-duplicity/pull/51))

**Note:** The removal of the S3 key check could be considered a major change but on close inspection it turned out this
check didn't work as expected. First of all it required the explicit usage of the profiles's `duply_version` parameter 
and secondly the implementation had a bug in the version check which means it is unlikely this has been used 
successfully by anyone.

Further more the acceptance test infrastructure was updated to the latest version of [beaker](https://github.com/puppetlabs/beaker/)
and Debian 9 has replaced Debian 7.

## 2017-07-06 - Release 4.7.0

Add parameter for `MAX_FULLS_WITH_INCRS` ([#45](https://github.com/tohuwabohu/puppet-duplicity/pull/45)).

## 2017-06-21 - Release 4.6.0

Add support for Debian 9 ([#44](https://github.com/tohuwabohu/puppet-duplicity/pull/44)).

## 2017-04-22 - Release 4.5.3

Fix `concat::fragment` deprecation warnings when using puppetlabs-concat 2.x.

## 2017-04-12 - Release 4.5.2

Do not ensure absent python-paramiko ([#41](https://github.com/tohuwabohu/puppet-duplicity/pull/41)).

## 2017-04-11 - Release 4.5.1

Fix profile folder default permissions ([#40](https://github.com/tohuwabohu/puppet-duplicity/pull/40)).

## 2017-03-12 - Release 4.5.0

Two changes to improve the compatibility on Ubuntu 16.04

* Add option to make use of yo61/logrotate module optional ([#36](https://github.com/tohuwabohu/puppet-duplicity/pull/36)); 
  the default logrotate configuration is currently broken on Ubuntu 16.04 until [yo61/puppet-logrotate#43](https://github.com/yo61/puppet-logrotate/pull/43) 
  is merged
* Add missing python-paramiko package ([#39](https://github.com/tohuwabohu/puppet-duplicity/pull/39))

## 2017-03-07 - Release 4.4.2

Set `TARGET_USER` only if it's a non-empty string ([#35](https://github.com/tohuwabohu/puppet-duplicity/pull/35)).

## 2017-02-25 - Release 4.4.1

Re-release of 4.4.0 due to unwanted files contained in the tarball uploaded to the forge.

## 2017-02-25 - Release 4.4.0 (deleted from the forge)

The purge behaviour of config directories is now configurable ([#34](https://github.com/tohuwabohu/puppet-duplicity/pull/34))
and the module supports [puppetlabs/concat](http://forge.puppetlabs.com/puppetlabs/concat) 2.x officially.

## 2017-01-04 - Release 4.3.0

The `max_age` parameter can be set in the profile ([#33](https://github.com/tohuwabohu/puppet-duplicity/pull/33)).

## 2016-12-06 - Release 4.2.0

Allow the Duply batch command to be customized, e.g. change the used operators or add additional commands
([#31](https://github.com/tohuwabohu/puppet-duplicity/issues/31)).

## 2016-11-27 - Release 4.1.0
### Summary

This release ships two major changes

* Improve compatibility with duply 1.10+ which removed the environment variable handling required by many storage
  backends, e.g. `NoAuthHandlerFound: No handler was ready to authenticate. (S3)` ([#25](https://github.com/tohuwabohu/puppet-duplicity/issues/25))
* Add support to control the niceness ([#28](https://github.com/tohuwabohu/puppet-duplicity/pull/28))

### Upgrade notes

Duply 1.10+ removed support for many backend-specific environment variables ([see changelog](http://duply.net/wiki/index.php/Duply-Changelog)):

> ... and instead opted for removing almost all code that deals with special env vars required by backends.
> adding and modifying these results in too much overhead so i dropped this feature. the future alternative for users is
> to consult the duplicity manpage and add the needed export definitions to the conf file.

In order to upgrade to this version, it is now up to the client to provide the environment variables. This can be done
on a class or profile level. The specified variables are stored in duply's configuration file. Example:

```
class { 'duplicity':
  duply_environment => [
    "export AWS_ACCESS_KEY_ID='${my_access_key}'",
    "export AWS_SECRET_ACCESS_KEY='${my_secret_key}'",
  ],
}
```

### Minor

A couple of minor updates have been applied
* Consistent operating system names for `osfamily` checks ([#29](https://github.com/tohuwabohu/puppet-duplicity/pull/29))
* Add Ubuntu 16.04 to test matrix, remove Ubuntu 12.04
* Run beaker tests on travis CI

##2016-05-30 - Release 4.0.0
###Summary

This release adds compatibility with Puppet 4 ([#19](https://github.com/tohuwabohu/puppet-duplicity/issues/19),
[#20](https://github.com/tohuwabohu/puppet-duplicity/issues/20)).

**Note:** As part of the upgrade the abandoned module [rodjek/logrotate](https://forge.puppetlabs.com/rodjek/logrotate)
was replaced with [yo61/logrotate](https://forge.puppetlabs.com/yo61/logrotate).

##2016-04-25 - Release 3.6.3
###Summary

Add missing resource dependency in `duplicity::file` ([#24](https://github.com/tohuwabohu/puppet-duplicity/issues/24)).

##2016-04-24 - Release 3.6.2
###Summary

Fix `No content, source or symlink specified` warnings caused by concat when neither `$exec_before_content` nor
`$exec_before_source` are specified (same for `$exec_after_*`, [#23](https://github.com/tohuwabohu/puppet-duplicity/issues/23)).

##2016-04-17 - Release 3.6.1
###Summary

Update cron job to use correct `purgeFull`/`purge-full` command on CentOS 6 ([#22](https://github.com/tohuwabohu/puppet-duplicity/pull/22)).

##2016-03-13 - Release 3.6.0
###Summary

This release fixes a bug in the `duplicity::profile`'s cron job when using a version of duply that is lower than 1.7.1.
The bug affects the default system package provided by Debian 7 / Ubuntu 14.04 and below.

Furthermore, the `pre` and `post` scripts run before and after a backup can be replaced with custom ones.

* Add the ability to specify before/after script source/content in a profile ([#21](https://github.com/tohuwabohu/puppet-duplicity/pull/21))
* Fix pre 1.7.1 error (purgeFull vs. purge-full) ([#9](https://github.com/tohuwabohu/puppet-duplicity/pull/9))

The unit and acceptance test infrastructure has been updated as well:

* Test only against the latest Puppet 3.x version
* Test against Puppet 4.x (experimental, Puppet 4 is currently not
  supported due to issues with logrotate)
* Replace VirtualBox with Docker

##2016-01-10 - Release 3.5.2
###Summary

Add scope to `profile_exec_*` calls so that duplicity works with Puppet 4 ([#18](https://github.com/tohuwabohu/puppet-duplicity/pull/18)).

##2015-12-30 - Release 3.5.1
###Summary

Fixes a bug which causes an error when trying to restore a `duplicity::file`' file resource whose path contains
whitespaces. This issue effects the `path` parameter - the root - of the `duplicity::file` resource only, e.g.

```
duplicity::file { '/path/with/white space': }
```

Any path that is part of an inclusion list is NOT effected by the problem.

##2015-10-18 - Release 3.5.0
###Summary

Allow configuration of the Duply cache (ARCH_DIR) directory ([#17](https://github.com/tohuwabohu/puppet-duplicity/pull/17)).

##2015-09-09 - Release 3.4.0
###Summary

Add ability to pass extra options to duplicity ([#12](https://github.com/tohuwabohu/puppet-duplicity/pull/12)).

##2015-07-21 - Release 3.3.0
###Summary

Add extra option that allows to download duply using a proxy server ([#11](https://github.com/tohuwabohu/puppet-duplicity/pull/11)).

##2015-07-11 - Release 3.2.0
###Summary

The duply executable is no longer referenced directly but sourced from the `PATH` environment variable instead (#10). As
a result of this change, the `duply_executable` parameter has been deprecated and was replaced with the more specific
`exec_path` and `duply_archive_executable` parameters.

####Further changes
* Improved compatibility with Puppet 4 ([logrotate #46](https://github.com/rodjek/puppet-logrotate/issues/46)).

##2015-04-15 - Release 3.1.1
###Summary

Fix up too restrictive permission on files contained in the tarball that was published to the forge during the last
release (see [#8](https://github.com/tohuwabohu/puppet-duplicity/issues/8)).

##2015-04-12 - Release 3.1.0
###Summary

By default, all backups are encrypted via GPG. With the new boolean `gpg_encryption` parameter, this behaviour can be
turned off in case encryption is not necessary. It can be configured on a per-profile level (see
[#3](https://github.com/tohuwabohu/puppet-duplicity/issues/3)).

##2015-03-31 - Release 3.0.1
###Summary

Just a bugfix release that fixes the wrong `duply_executable` being used.

##2015-03-31 - Release 3.0.0
###Summary

This release adds a better separation of the configuration parameters when using the package vs. archive resource type.

Furthermore, it adds support for RHEL/CentOS 6.

####Changes to default behavior
* Package provider archive: the duply archive is now downloaded directly from sourceforge instead some dude's dropbox
  account; using HTTP by default to facilitate the usage of a HTTP proxy
* Package provider archive: the ambigious usage of the `duply_package_ensure` parameter to transport the default version
  and the packate state has been replaced with the `duply_archive_version` parameter
* On RedHat-based systems, the `yum` package is preferred over the sourceforge one

####Further changes
* Documentation of the `duplicity` class has been reviewed
* Using the archive no longer requires to specify `duply_package_name` or `duply_archive_url`; setting
  `duply_archive_version` and `duply_archive_md5sum` is enough
* Add support for Ubuntu 12.04 and 14.04
* Add system tests

##2014-12-25 - Release 2.0.0
###Summary

* Add default package name/version/handler for Debian based distributions
* Replace gini/archive with camptocamp/archive
* Fix broken example in README
