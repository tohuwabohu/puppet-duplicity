require 'spec_helper'

describe 'duplicity::file' do
  let(:title) { '/path/to/file' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }
  let(:include_fragment) { '/etc/duply/system/include/b4a91649090a2784056565363583d067' }
  let(:exclude_fragment) { '/etc/duply/system/exclude/b4a91649090a2784056565363583d067' }
  let(:restore_exec) { "restore /path/to/file" }

  describe 'by default' do
    let(:params) { {} }

    specify {
      should contain_concat__fragment(include_fragment).with(
        'ensure'  => 'present',
        'content' => "+ /path/to/file"
      )
    }
    specify { should contain_exec(restore_exec).with_command(/system fetch path\/to\/file \/path\/to\/file\s*$/) }
    specify { should contain_exec(restore_exec).with_creates('/path/to/file') }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_concat__fragment(include_fragment).with_ensure('absent') }
    specify { should_not contain_exec(restore_exec) }
  end

  describe 'with ensure backup' do
    let(:params) { {:ensure => 'backup'} }

    specify { should_not contain_exec(restore_exec) }
  end

  describe 'with invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    specify do
      expect { should contain_concat__fragment(include_fragment) }.to raise_error(Puppet::Error, /ensure/)
    end
  end

  describe 'with invalid path' do
    let(:params) { {:path => 'relative/path'} }

    specify do
      expect { should contain_concat__fragment(include_fragment) }.to raise_error(Puppet::Error, /path/)
    end
  end

  describe 'should acccept custom path' do
    let(:params) { {:path => '/a/b/c'} }

    specify { should contain_exec('restore /a/b/c').with_command(/system fetch a\/b\/c \/a\/b\/c\s*$/) }
  end

  describe 'with empty profile' do
    let(:params) { {:profile => ''} }

    specify do
      expect { should contain_concat__fragment(include_fragment) }.to raise_error(Puppet::Error, /profile/)
    end
  end

  describe 'with invalid profile' do
    let(:params) { {:profile => 'in val$d'} }

    specify do
      expect { should contain_concat__fragment(include_fragment) }.to raise_error(Puppet::Error, /profile/)
    end
  end

  describe 'with exclude => ["/a/b"]' do
    let(:params) { {:exclude => ['/a/b']} }

    specify { should contain_concat__fragment(exclude_fragment).with_content(/^\- \/a\/b$/) }
  end

  describe 'with exclude => ["/a", "/b"]' do
    let(:params) { {:exclude => ['/a', '/b']} }

    specify { should contain_concat__fragment(exclude_fragment).with_content(/^\- \/a$/) }
    specify { should contain_concat__fragment(exclude_fragment).with_content(/^\- \/b$/) }
  end

  describe 'with invalid exclude' do
    let(:params) { {:exclude => 'not-an-array'} }

    specify {
      expect { should contain_concat__fragment(exclude_fragment) }.to raise_error(Puppet::Error, /exclude/)
    }
  end

  describe 'with timeout => 60' do
    let(:params) { {:timeout => 60} }

    specify { should contain_exec(restore_exec).with_timeout(60) }
  end

  describe 'should acccept custom path' do
    let(:params) { {:path => '/a/b/c'} }

    specify { should contain_exec('restore /a/b/c').with_creates('/a/b/c') }
  end

  describe 'should accept creates => /a/b/c' do
    let(:params) { {:creates => '/a/b/c'} }

    specify { should contain_exec(restore_exec).with_creates('/a/b/c') }
  end

  describe 'should not accept invalid creates' do
    let(:params) { {:creates => 'invalid-path'} }

    specify {
      expect { should contain_exec(restore_exec) }.to raise_error(Puppet::Error, /invalid-path/)
    }
  end

  describe 'should not accept invalid force' do
    let(:params) { {:force => 'invalid'} }

    specify {
      expect { should contain_exec(restore_exec) }.to raise_error(Puppet::Error, /force/)
    }
  end

  describe 'with force => true' do
    let(:params) { {:force => true} }

    specify { should contain_exec(restore_exec).with_command(/system fetch path\/to\/file \/path\/to\/file --force$/) }
  end
end
