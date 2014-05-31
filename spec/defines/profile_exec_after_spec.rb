require 'spec_helper'

describe 'duplicity::profile_exec_after' do
  let(:title) { 'example/foobar' }
  let(:facts) { {:concat_basedir => '/path/to/dir'} }

  describe 'by default' do
    let(:params) { {:profile => 'example', :content => 'foobar'} }

    specify {
      should contain_concat__fragment('profile-exec-after/example/foobar').with(
        'ensure'  => 'present',
        'target'  => '/etc/duply/example/post',
        'content' => 'foobar'
      )
    }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should contain_concat__fragment('profile-exec-after/example/foobar').with_ensure('absent') }
  end
end
