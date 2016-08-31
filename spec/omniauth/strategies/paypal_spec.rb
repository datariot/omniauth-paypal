require 'spec_helper'
require 'omniauth-paypal'

describe OmniAuth::Strategies::PayPal do
  subject do
    OmniAuth::Strategies::PayPal.new(nil, @options || {})
  end

  let(:user_info_hash) {
    {
      'payer_id' => '6ZGXTKGQ3L35N',
      'family_name' => 'Harkonnen',
      'verified' => 'true',
      'name' => 'Mikka Harkonnen',
      'account_type' => 'PERSONAL',
      'given_name' => 'Mikka',
      'user_id' =>
        'https://www.paypal.com/webapps/auth/identity/user/' \
        'K43VMDJ6KaRJgMVUFRGT3hqpdnhg1tDYLmlPgxl1HRE',
      'address' => {
        'postal_code' => 'W12 4LQ',
        'locality' => 'Wolverhampton',
        'region' => 'West Midlands',
        'country' => 'GB',
        'street_address' => '1 Main Terrace'
      },
      'verified_account' => 'true',
      'language' => 'en_GB',
      'zoneinfo' => 'America/Los_Angeles',
      'locale' => 'en_GB',
      'phone_number' => '0356739226',
      'account_creation_date' => '2016-08-30',
      'email' => 'test2@login.com',
      'age_range' => '36-40',
      'birthday' => '1975-10-10'
    }
  }

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
      expect(counter).to eq('ok')
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to eq('/auth/paypal/callback')
    end
  end

  describe '#uid' do
    before do
      allow(subject).to receive(:raw_info).and_return(user_info_hash)
    end

    it 'returns the final part of the PayPal user_id URL' do
      expect(subject.uid).to eql('K43VMDJ6KaRJgMVUFRGT3hqpdnhg1tDYLmlPgxl1HRE')
    end
  end

  describe '#info' do
    before do
      allow(subject).to receive(:raw_info).and_return(user_info_hash)
    end

    it 'includes the name' do
      expect(subject.info[:name]).to eq(user_info_hash['name'])
    end

    it 'includes the first_name' do
      expect(subject.info[:first_name]).to eq(user_info_hash['given_name'])
    end

    it 'includes the last_name' do
      expect(subject.info[:last_name]).to eq(user_info_hash['family_name'])
    end

    it 'includes the email' do
      expect(subject.info[:email]).to eq(user_info_hash['email'])
    end

    it 'includes the location as city and state when address exists' do
      location = [
        user_info_hash['address']['locality'],
        user_info_hash['address']['region']
      ].join(', ')
      expect(subject.info[:location]).to eq(location)
    end

    it 'does not include the location when address does not exist' do
      user_info_hash.delete('address')
      expect(subject.info[:location]).to be_nil
    end

    it 'includes the phone' do
      expect(subject.info[:phone]).to eq(user_info_hash['phone_number'])
    end
  end

  describe '#extra' do
    before do
      allow(subject).to receive(:raw_info).and_return(user_info_hash)
    end

    it 'contains raw info as a hash value of :raw_info' do
      expect(subject.extra).to eq({ 'raw_info' => user_info_hash })
    end
  end
end
