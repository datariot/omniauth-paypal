require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "https://identity.x.com/xidentity/resources/profile/me"
      DEFAULT_MAX_AUTH_AGE = 10

      option :client_options, {
        :site          => 'https://identity.x.com',
        :authorize_url => '/xidentity/resources/authorize',
        :token_url     => '/xidentity/oauthtokenservice'
      }

      option :authorize_options, [:scope, :max_auth_age]

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
          'timezone' => raw_info['timezone']
        }
      end

      def email(raw_info)
        unless raw_info['emails'].empty?
          raw_info['emails'][0]
        end
      end

      def raw_info
        @raw_info ||= load_identity()
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
          params[:max_auth_age] ||= DEFAULT_MAX_AUTH_AGE
          puts params
        end
      end

      private
        def load_identity
          access_token.options[:mode] = :query
          access_token.options[:param_name] = :oauth_token
          response = access_token.get('https://identity.x.com/xidentity/resources/profile/me')
          response.parsed['identity']
        end
    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'