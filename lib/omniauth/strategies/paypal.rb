require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = "openid profile"
      DEFAULT_RESPONSE_TYPE = "code"
      SANDBOX_SITE = "https://api.sandbox.paypal.com"
      SANDBOX_AUTHORIZE_URL = 'https://www.sandbox.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize'

      option :client_options, {
        :site          => 'https://api.paypal.com',
        :authorize_url => 'https://www.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize',
        :token_url     => '/v1/identity/openidconnect/tokenservice',
      }

      option :authorize_options, [:scope, :response_type]
      option :provider_ignores_state, true
      option :sandbox, false

      uid { @parsed_uid ||= (/\/([^\/]+)\z/.match raw_info['user_id'])[1] } #https://www.paypal.com/webapps/auth/identity/user/baCNqjGvIxzlbvDCSsfhN3IrQDtQtsVr79AwAjMxekw => baCNqjGvIxzlbvDCSsfhN3IrQDtQtsVr79AwAjMxekw

      info do
        prune!({
          name: raw_info['name'],
          email: raw_info['email'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
          location: build_user_location,
          phone: raw_info['phone_number'],
          image: raw_info['picture']
        })
      end

      extra do
        prune!({'raw_info' => raw_info})
      end

      def setup_phase
        if options.sandbox
          options.client_options[:site] = SANDBOX_SITE
          options.client_options[:authorize_url] = SANDBOX_AUTHORIZE_URL
        end
        super
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end

      def raw_info
        @raw_info ||= load_identity
      end

      def authorize_params
        super.tap do |params|
          params[:scope] ||= DEFAULT_SCOPE
          params[:response_type] ||= DEFAULT_RESPONSE_TYPE
        end
      end

      def custom_build_access_token
        access_token =
        if request.xhr? && request.params['code']
          verifier = request.params['code']
          redirect_uri = request.params['redirect_uri'] || 'postmessage'
          client.auth_code.get_token(verifier, get_token_options(redirect_uri), deep_symbolize(options.auth_token_params || {}))
        elsif request.params['code'] && request.params['redirect_uri']
          verifier = request.params['code']
          redirect_uri = request.params['redirect_uri']
          client.auth_code.get_token(verifier, get_token_options(redirect_uri), deep_symbolize(options.auth_token_params || {}))
        else
          verifier = request.params["code"]
          client.auth_code.get_token(verifier, get_token_options(callback_url), deep_symbolize(options.auth_token_params))
        end
        access_token
      end
      alias_method :build_access_token, :custom_build_access_token

      private

      def load_identity
        access_token.options[:mode] = :query
        access_token.options[:param_name] = :access_token
        access_token.options[:grant_type] = :authorization_code
        access_token.get('/v1/identity/openidconnect/userinfo', { :params => { :schema => 'openid'}}).parsed || {}
      end

      def get_token_options(redirect_uri)
        { :redirect_uri => redirect_uri }.merge(token_params.to_hash(:symbolize_keys => true))
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def build_user_location
        return unless raw_info['address']
        location = [
          raw_info['address']['locality'],
          raw_info['address']['region']
        ].compact.join(', ')
      end
    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'
