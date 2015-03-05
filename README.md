#duplicity

##Overview

Configure [duply](http://duply.net/) on top of [duplicity](http://duplicity.nongnu.org/) to provide a profile-based,
easy to use backup and restore system.

##Usage

Install duplicity and duply with all default values.

```
class { 'duplicity':
  ensure => present,
}
```

Install a more recent version of duply from [the sourceforge project page](http://sourceforge.net/projects/ftplicity/)

```
class { 'duplicity':
  duply_package_provider => 'archive',
  duply_archive_version  => '1.9.1',
  duply_archive_md5sum   => 'd584940b9c740c81a2a081bc154084b9',
}
```

Specify the backup server to be used; see the duplicity documentation for more information about the available protocols.

```
class { 'duplicity':
  backup_target_url      => 'ftps://backup.example.com/',
  backup_target_username => 'username',
  backup_target_password => 'password',
}
```

Configure a simple backup profile. It will run once a day, do incremental backups by default and create a full backup if
the previous full backup is older than 7 days. Duplicity will keep at most two full backups and purge older ones.

```
duplicity::profile { 'system':
  full_if_older_than => '7D',
  max_full_backups   => 2,
  cron_hour          => '4',
  cron_minute        => '0',
}
```

Backup a file and restore it from a previous backup if it is not existing. Setting `ensure` to `backup` will only
backup the file but not restore it.

Note: a directory will only be restored if the directory is not existing - an empty directory is not replaced.

```
duplicity::file { '/path/to/file':
  ensure => present,
}
```

Backup a directory by using a specific backup profile and exclude a bunch of files.

```
$data_dir = '/var/lib/jira'

duplicity::file { $data_dir:
  profile => 'jira',
  exclude => [
    "${$data_dir}/caches",
    "${$data_dir}/tmp",
    "${$data_dir}/plugins/.osgi-plugins/felix/felix-cache",
    "${$data_dir}/plugins/.osgi-plugins/transformed-plugins",
  ],
}
```

Define a GnuPG key pair `BEEF1234` to be used to de/encrypt the backup on the node itself and configure the backup
profile to use it. The encrytion key `ALICE00001` is used to decrypt the backup on another node (e.g. the admin's
workstation).

```
duplicity::private_key { 'BEEF1234':
  content => hiera('duplicity::private_key::BEEF1234'),
}

duplicity::public_key { 'BEEF1234':
  content => template('path/to/BEEF1234.pub.asc.erb'),
}

class { 'duplicity':
  gpg_encryption_keys => ['ALICE00001', 'BEEF1234'],
  gpg_signing_key     => 'BEEF1234',
}
```

##Limitations

The module has been tested on the following operating systems. Testing and patches for other platforms are welcome.

* Debian Linux 6.0 (Squeeze)
* Debian Linux 7.0 (Wheezy)

[![Build Status](https://travis-ci.org/tohuwabohu/puppet-duplicity.png?branch=master)](https://travis-ci.org/tohuwabohu/puppet-duplicity)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
