require 'spec_helper'

describe 'duplicity::profile_exec_after' do
  let(:title) { 'example/foobar' }

  describe 'by default' do
    let(:params) { {:profile => 'example', :content => 'foobar'} }

    specify {
      should contain_concat__fragment('profile-exec-after/example/foobar').with(
        'target'  => '/etc/duply/example/post',
        'content' => 'foobar'
      )
    }
  end

  describe 'with ensure absent' do
    let(:params) { {:ensure => 'absent'} }

    specify { should_not contain_concat__fragment('profile-exec-after/example/foobar') }
  end
end
