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
