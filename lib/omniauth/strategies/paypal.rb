require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "https://identity.x.com/xidentity/resources/profile/me"
      DEFAULT_RESPONSE_TYPE = "code"

      option :client_options, {
        :site          => 'https://identity.x.com',
        :authorize_url => '/xidentity/resources/authorize',
        :token_url     => '/xidentity/oauthtokenservice'
      }

      option :authorize_options, [:scope, :response_type]

      uid { raw_info['userId'] }
    
      info do
        {
          'name' => raw_info['fullName'],
          'first_name' => raw_info['firstName'],
          'last_name' => raw_info['lastName'],
          'email' => email(raw_info),
          'phone' => raw_info['telephoneNumber']
        }
      end

      extra do
        {
          'emails' => raw_info['emails'],
          'addresses' => raw_info['addresses'],
          'status' => raw_info['status'],
          'language' =>  raw_info['language'],
          'dob' => raw_info['dob'],
          'timezone' => raw_info['timezone'],
          'payerID' => raw_info['payerID']
        }
      end

      def email(raw_info)
        if raw_info['emails'] && !raw_info['emails'].empty?
          raw_info['emails'][0]
        end
      end

      def raw_info
        @raw_info ||= load_identity()
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
          params[:response_type] ||= DEFAULT_RESPONSE_TYPE
        end
      end

      private
        def load_identity
          access_token.options[:mode] = :query
          access_token.options[:param_name] = :oauth_token
          access_token.options[:grant_type] = :authorization_code
          response = access_token.get('/xidentity/resources/profile/me')
          identity = response.parsed['identity']
          puts identity
          identity
        end
    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'