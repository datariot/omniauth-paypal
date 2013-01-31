# OmniAuth PayPal

**Note:** This gem is designed to work with OmniAuth 1.0 library.

This gem contains the PayPal Access strategy for OmniAuth.

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-paypal', :git => "git://github.com/datariot/omniauth-paypal.git"
```

Then `bundle install`.

## Usage

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal, ENV['APP_ID'], ENV['APP_TOKEN'],
    { :scope => "profile email address phone https://uri.paypal.com/services/paypalattributes"}
end
```

To see what each scope gives you access to see here:
https://www.x.com/developers/paypal/documentation-tools/quick-start-guides/oauth-openid-connect-integration-paypal

## info

PayPal Access information https://www.x.com/developers/x.commerce/products/paypal-access

The info returned currently is:

    info['name']
    info['email']
    info['first_name']
    info['last_name]
    info['phone']
    info['location']

    extra['verified_account'] # true / false
    extra['family_name']
    extra['language']
    extra['phone_number']
    extra['locale']
    extra['zoneinfo']
    extra['name']
    extra['email']
    extra['account_type'] # :premier, :business or :personal
    extra['given_name']
    extra['user_id']

To register your application for PayPal identity: https://www.x.com/products/access/applications/submit

## License

Copyright (c) 2011 by veloGraf Systems

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.