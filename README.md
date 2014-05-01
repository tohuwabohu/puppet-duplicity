#duplicity

##Overview

Install duplicity and manage its configuration.

##Usage

Install duplicity with all default values.

Example:

```
class { 'duplicity':
  ensure => present,
}
```

##Limitations

The module has been tested on the following operating systems. Testing and patches for other platforms are welcome.

* Debian Linux 6.0 (Squeeze)

[![Build Status](https://travis-ci.org/tohuwabohu/tohuwabohu-duplicity.png?branch=master)](https://travis-ci.org/tohuwabohu/tohuwabohu-duplicity)

##Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
