require 'spec_helper'
require 'omniauth-paypal'

describe OmniAuth::Strategies::PayPal do
  subject do
    OmniAuth::Strategies::PayPal.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'has correct PayPal site' do
      expect(subject.client.site).to eq('https://api.paypal.com')
    end

    it 'has correct PayPal sandbox site' do
      @options = { :sandbox => true }
      subject.setup_phase
      expect(subject.client.site).to eq('https://api.sandbox.paypal.com')
    end

    it 'has correct authorize url' do
      expect(subject.client.options[:authorize_url]).to eq('https://www.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize')
    end

    it 'has correct sandbox authorize url' do
      @options = { :sandbox => true }
      subject.setup_phase
      expect(subject.client.options[:authorize_url]).to eq('https://www.sandbox.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize')
    end

    it 'has correct token url' do
      expect(subject.client.options[:token_url]).to eq('/v1/identity/openidconnect/tokenservice')
    end

    it 'runs the setup block if passed one' do
      counter = ''
      @options = { :setup => Proc.new { |env| counter = 'ok' } }
      subject.setup_phase
      expect(counter).to eq("ok")
    end
  end

  describe '#callback_path' do
    it "has the correct callback path" do
      expect(subject.callback_path).to eq('/auth/paypal/callback')
    end
  end

end
