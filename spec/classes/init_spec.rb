require 'spec_helper'

describe 'duplicity' do
  let(:title) { 'duplicity' }

  describe 'by default' do
    let(:params) { {} }

    it { should contain_package('duplicity').with(
        'ensure' => 'installed',
        'name'   => 'duplicity'
      )
    }
    it { should contain_archive('duply_1.7.3').with(
        'ensure'     => 'present',
        'target'     => '/opt',
        'src_target' => '/var/cache/puppet/archives'
      )
    }
    it { should contain_file('/usr/local/sbin/duply') }
    it {
      should contain_file('/etc/duply').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644'
      )
    }
    it {
      should contain_file('/etc/duply-keys').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644'
      )
    }
    it {
      should contain_file('/etc/duply-keys/public').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644'
      )
    }
    it {
      should contain_file('/etc/duply-keys/private').with(
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0600'
      )
    }
    it { should contain_file('/var/log/duply') }
    it { should contain_logrotate__rule('duply') }
  end

  describe 'by default on Debian' do
    let(:facts) { {:osfamily => 'debian'} }

    it { should contain_package('duply').with_ensure('installed') }
  end

  describe 'with duplicity_package_ensure => 1.2.3' do
    let(:params) { {:duplicity_package_ensure => '1.2.3'} }

    it { should contain_package('duplicity').with_ensure('1.2.3') }
  end

  describe 'with duplicity_package_ensure => 0.6.18-3~bpo60+1' do
    let(:params) { {:duplicity_package_ensure => '0.6.18-3~bpo60+1'} }

    it { should contain_package('duplicity').with_ensure('0.6.18-3~bpo60+1') }
  end

  describe 'with empty duplicity_package_ensure' do
    let(:params) { {:duplicity_package_ensure => ''} }

    it do
      expect { should contain_package('duplicity') }.to raise_error(Puppet::Error, /package_ensure/)
    end
  end

  describe 'with duplicity_package_name => foobar' do
    let(:params) { {:duplicity_package_name => 'foobar'} }

    it { should contain_package('duplicity').with_name('foobar') }
  end

  describe 'with empty duplicity_package_name' do
    let(:params) { {:duplicity_package_name => ''} }

    it do
      expect { should contain_package('duplicity') }.to raise_error(Puppet::Error, /package_name/)
    end
  end

  describe 'with duply_package_ensure => 1.2.3' do
    let(:params) { {:duply_package_ensure => '1.2.3', :duply_package_provider => '', :duply_package_name => 'duply'} }

    it { should contain_package('duply').with_ensure('1.2.3') }
  end

  describe 'with empty duply_package_ensure' do
    let(:params) { {:duply_package_ensure => ''} }

    it do
      expect { should contain_package('duply') }.to raise_error(Puppet::Error, /package_ensure/)
    end
  end

  describe 'with duply_package_name => foobar' do
    let(:params) { {:duply_package_name => 'foobar', :duply_package_provider => ''} }

    it { should contain_package('duply').with_name('foobar') }
  end

  describe 'with custom duply_package_provider and empty duply_package_name' do
    let(:params) { {:duply_package_provider => 'apy', :duply_package_name => ''} }

    it do
      expect { should contain_package('duply') }.to raise_error(Puppet::Error, /package_name/)
    end
  end

  describe 'with duply_package_provider => apt' do
    let(:params) { {:duply_package_provider => 'apt', :duply_package_name => 'duply'} }

    it { should contain_package('duply').with_provider('apt') }
  end

  describe 'with empty duply_package_provider' do
    let(:params) { {:duply_package_provider => '', :duply_package_name => 'duply'} }

    it { should contain_package('duply').with_provider('') }
  end
end

