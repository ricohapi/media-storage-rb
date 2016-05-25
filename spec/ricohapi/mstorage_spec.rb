require 'spec_helper'

describe RicohAPI::MStorage do
  subject { RicohAPI::MStorage }
  after { subject.debugging = false }

  it 'has a version number' do
    RicohAPI::MStorage::VERSION.should_not be nil
  end

  it 'knows necessary endponints and scopes' do
    RicohAPI::MStorage::BASE_URL.should_not be nil
    RicohAPI::MStorage::SCOPE.should_not be nil
  end

  context 'as default' do
    its(:logger) { should be_a Logger }
    it { should_not be_debugging }
  end

  describe '.debug!' do
    before { subject.debug! }
    it { should be_debugging }
  end

  describe '.http_client' do
    context 'with http_config' do
      before do
        subject.http_config do |config|
          config.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
          config.connect_timeout = 30
          config.send_timeout    = 40
          config.receive_timeout = 60
        end
      end

      it 'should configure Rack::OAuth2 and FbGraph2 http_client' do
        subject.http_client.ssl_config.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
        subject.http_client.connect_timeout.should == 30
        subject.http_client.send_timeout.should    == 40
        subject.http_client.receive_timeout.should == 60
      end
    end
  end
end
