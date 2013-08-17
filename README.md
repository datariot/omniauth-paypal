# OmniAuth PayPal

**Note:** This gem is designed to work with OmniAuth 1.0 library.

This gem contains the PayPal Access using OpenID strategy for OmniAuth.

## Installing

Add to your `Gemfile`:

```ruby
gem "omniauth-paypal"
```

Then `bundle install`.

## Usage

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :paypal, ENV['APP_ID'], ENV['APP_TOKEN']
end
```

## info

PayPal Access information https://www.x.com/developers/x.commerce/products/paypal-access

The maximum info returned currently is:

    info['name']
    info['email']
    info['first_name']
    info['last_name]
    info['location']
    info['phone']

    extra['account_type']
    extra['user_id']
    extra['address']['postal_code']
    extra['address']['locality']
    extra['address']['country']
    extra['address']['street_address']
    extra['verified_account']
    extra['language']
    extra['zoneinfo']
    extra['locale']
    extra['account_creation_date']

PayPal docs claim that day of birth also may be returned, but I was not able to find this param name, so it's not currently included.

Actual set of attributes depends on these possible scopes:

    openid
    profile
    email
    address
    phone
    https://uri.paypal.com/services/paypalattributes
(the last is scope name, not a link)

For details see [this section](https://www.x.com/developers/paypal/documentation-tools/quick-start-guides/oauth-openid-connect-integration-paypal##attributes).

To register your application for PayPal Access follow these instructions: https://www.x.com/developers/paypal/how-to-guides/how-register-application-paypal-access


## Example of result auth hash
With all scopes requested.

    provider: paypal
    uid: bathjJwvdhKjgfgh8Jd745J7dh5Qkgflbnczd65dfnw
    info:
      name: John Smith
      email: example@example.com
      first_name: John
      last_name: Smith
      location: Moscow
      phone: "71234567890"
    credentials:
      token: <token>
      refresh_token: <refresh token>
      expires_at: 1355082790
      expires: true
    extra:
      account_type: PERSONAL
      user_id: https://www.paypal.com/webapps/auth/identity/user/bathjJwvdhKjgfgh8Jd745J7dh5Qkgflbnczd65dfnw
      address:
        postal_code: "123456"
        locality: Moscow
        country: RU
        street_address: Red square, 1
      verified_account: "true"
      language: en_US
      zoneinfo: America/Los_Angeles
      locale: en_US
      account_creation_date: "2008-04-21"

## License

Copyright (c) 2011 by veloGraf Systems

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
