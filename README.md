#duplicity

##Overview

Install duplicity and manage its configuration.

##Usage

Install duplicity with all default values.

```
class { 'duplicity':
  ensure => present,
}
```

Backup a file and restore it from a previous backup if it is not existing.

```
duplicity::file { '/path/to/file':
  ensure => present,
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
