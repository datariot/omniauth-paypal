require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      DEFAULT_RESPONSE_TYPE = "code"

      option :client_options, {
        :site          => 'https://www.paypal.com',
        :authorize_url => '/webapps/auth/protocol/openidconnect/v1/authorize',
        :token_url     => '/webapps/auth/protocol/openidconnect/v1/tokenservice'
      }

      option :authorize_options, [:scope, :response_type, :schema]
      option :provider_ignores_state, true
      option :scope, 'profile email'

      uid { raw_info['user_id'].split('/').last }
    
      info do
        {
          'name' => raw_info['name'],
          'first_name' => raw_info['given_name'],
          'last_name' => raw_info['family_name'],
          'email' => raw_info['email'],
          'phone' => raw_info['phone_number'],
          'location' => "#{raw_info['locality']}, #{raw_info['country']}",
          
        }
      end

      extra do
        raw_info.merge {
          'verified_account' => raw_info['verified_account'] == 'true',
          'account_type' => raw_info['account_type'].downcase.to_sym
        }
      end

      def raw_info
        @raw_info ||= load_identity()
      end

      def authorize_params
        super.tap do |params|
          params[:schema] = 'openid'
          params[:scope] = "openid #{params[:scope]}".rstrip
          params[:response_type] ||= DEFAULT_RESPONSE_TYPE
        end
      end

      private

        def load_identity
          access_token.options[:mode] = :query
          access_token.options[:param_name] = :access_token
          access_token.options[:grant_type] = :authorization_code
          response = access_token.get('/webapps/auth/protocol/openidconnect/v1/userinfo?schema=openid')
          response.parsed
          throw response.parsed
        end
    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'