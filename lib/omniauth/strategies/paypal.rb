require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PayPal < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site          => 'https://identity.x.com',
        :authorize_url => '/xidentity/resources/authorize',
        :token_url     => '/xidentity/oauthtokenservice'
      }

      def request_phase
        super
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(
        puts access_token.to_yaml
          super, {
            'uid' => @access_token.client.id
          }
        )
      end
    
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
          'address' => raw_info['addresses'],
          'status' => raw_info['status']  
        }
      end

      def email(raw_info)
        unless raw_info['emails'].empty?
          raw_info['emails'][0]
        end
      end

      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = :oauth_token
        response = access_token.get('https://identity.x.com/xidentity/resources/profile/me').parsed['identity']
        @raw_info ||= response
      end
    end
  end
end

OmniAuth.config.add_camelization 'paypal', 'PayPal'