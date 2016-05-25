require 'spec_helper'

describe RicohAPI::MStorage do
  it 'has a version number' do
    RicohAPI::MStorage::VERSION.should_not be nil
  end

  it 'knows necessary endponints and scopes' do
    RicohAPI::MStorage::BASE_URL.should_not be nil
    RicohAPI::MStorage::SCOPE.should_not be nil
  end
end
