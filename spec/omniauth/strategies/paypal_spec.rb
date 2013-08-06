require 'spec_helper'
require 'omniauth-paypal'

describe OmniAuth::Strategies::PayPal do
  subject do
    OmniAuth::Strategies::PayPal.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'has correct PayPal site' do
      subject.client.site.should eq('https://www.paypal.com')
    end

    it 'has correct authorize url' do
      subject.client.options[:authorize_url].should eq('/webapps/auth/protocol/openidconnect/v1/authorize')
    end

    it 'has correct token url' do
      subject.client.options[:token_url].should eq('/webapps/auth/protocol/openidconnect/v1/tokenservice')
    end
  end

  describe '#callback_path' do
    it "has the correct callback path" do
      subject.callback_path.should eq('/auth/paypal/callback')
    end
  end

end
