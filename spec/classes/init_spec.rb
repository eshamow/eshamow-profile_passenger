require 'spec_helper'
describe 'profile_passenger' do

  context 'with defaults for all parameters' do
    it { should contain_class('profile_passenger') }
  end
end
