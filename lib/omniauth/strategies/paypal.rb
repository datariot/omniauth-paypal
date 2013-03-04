require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "openid profile"
      DEFAULT_RESPONSE_TYPE = "code"

      option :client_options, {
        :site          => 'https://www.paypal.com',
        :authorize_url => '/webapps/auth/protocol/openidconnect/v1/authorize',
        :token_url     => '/webapps/auth/protocol/openidconnect/v1/tokenservice',
        :user_info     => '/webapps/auth/protocol/openidconnect/v1/userinfo'
      }

      option :authorize_options, [:scope, :response_type]
      option :provider_ignores_state, true

      uid { @parsed_uid ||= (/\/([^\/]+)\z/.match raw_info['user_id'])[1] } #https://www.paypal.com/webapps/auth/identity/user/baCNqjGvIxzlbvDCSsfhN3IrQDtQtsVr79AwAjMxekw => baCNqjGvIxzlbvDCSsfhN3IrQDtQtsVr79AwAjMxekw
    
      info do
        prune!({
                   'name' => raw_info['name'],
                   'email' => raw_info['email'],
                   'first_name' => raw_info['given_name'],
                   'last_name' => raw_info['family_name'],
                   'location' => (raw_info['address'] || {})['locality'],
                   'phone' => raw_info['phone_number']
               })
      end

      extra do
        prune!({
                   'account_type' => raw_info['account_type'],
                   'user_id' => raw_info['user_id'],
                   'address' => raw_info['address'],
                   'verified_account' => raw_info['verified_account'],
                   'language' => raw_info['language'],
                   'zoneinfo' => raw_info['zoneinfo'],
                   'locale' => raw_info['locale'],
                   'account_creation_date' => raw_info['account_creation_date']
               })
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
          access_token.options[:param_name] = :access_token
          access_token.options[:grant_type] = :authorization_code
          access_token.get(options.client_options.user_info, { :params => { :schema => 'openid'}}).parsed || {}
        end

        def prune!(hash)
          hash.delete_if do |_, value|
            prune!(value) if value.is_a?(Hash)
            value.nil? || (value.respond_to?(:empty?) && value.empty?)
          end
        end

    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'