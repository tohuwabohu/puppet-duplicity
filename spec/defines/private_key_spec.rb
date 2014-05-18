require 'spec_helper'

describe 'duplicity::private_key' do
  let(:title) { 'keyid' }
  let(:default_key_file) { '/etc/duply-keys/private/keyid.asc' }

  describe 'by default' do
    let(:params) { {:content => 'key-content'} }

    it {
      should contain_file('/etc/duply-keys/private/keyid.asc').with(
        'ensure'  => 'file',
        'content' => 'key-content',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0400',
      )
    }
  end

  describe 'should accept ensure => absent' do
    let(:params) { {:ensure => 'absent'} }

    it { should contain_file(default_key_file).with_ensure('absent') }
  end

  describe 'should not accept invalid ensure' do
    let(:params) { {:ensure => 'foobar'} }

    specify {
      expect { should contain_file(default_key_file) }.to raise_error(Puppet::Error, /ensure/)
    }
  end

  describe 'should not accept invalid keyid' do
    let(:params) { {:keyid => 'in-Va$id'} }

    specify {
      expect { should contain_file(default_key_file) }.to raise_error(Puppet::Error, /keyid/)
    }
  end

  describe 'should not accept missing content' do
    let(:params) { {} }

    specify {
      expect { should contain_file(default_key_file) }.to raise_error(Puppet::Error, /content/)
    }
  end
end
