# OmniAuth PayPal

**Note:** This gem is designed to work with OmniAuth 1.0 library.

This gem contains the Log In With PayPal strategy for OmniAuth.

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
  provider :paypal, ENV['APP_ID'], ENV['APP_TOKEN'], sandbox: true, scope: "openid profile email"
end
```

## Attributes and Scopes

Log In With PayPal information can be found on https://developer.paypal.com/webapps/developer/docs/integration/direct/log-in-with-paypal/

The actual set of attributes returned depends on the scopes set. The currently available scopes are:

```
openid
profile
email
address
phone
https://uri.paypal.com/services/paypalattributes
https://uri.paypal.com/services/expresscheckout
```

(those last 2 are scope names, not links)

For more details see the PayPal [list of attributes](https://developer.paypal.com/docs/integration/direct/identity/attributes/).

## Registering for an API key

To register your application for Log In With PayPal head over to the [PayPal Developer portal](https://developer.paypal.com/), log in and register for an application. Make sure to match your scope when registering your app to the scope provided when initializing Omniauth.

[A full tutorial is available](http://cristianobetta.com/blog/2013/09/27/integrating-login-with-paypal-into-rails/) on how to use Omniauth, Login With PayPal, and the PayPal Developer portal.

If the Paypal Sandbox does not like connecting with `localhost` for authentication during development, tools like [ngrok](https://ngrok.com) should be quite useful. For example, if using Rails, start the server with:

```
ngrok http 3000
```

and then set the return URL for the sandbox login app to the exposed `ngrok` server:

```
http://fe04daed.ngrok.io/users/auth/paypal/callback
```

## Example of result auth hash

With all scopes requested.

```ruby
{
  "provider" => "paypal",
  "uid" => "K43VMDJ6KaRJgMVUFRGT3hqpdnhg1tDYLmlPgxl1HRE",
  "info" => {
    "name" => "John Smith",
    "email" => "john.smith@test.com",
    "first_name" => "John",
    "last_name" => "Smith",
    "location" => "Wolverhampton, West Midlands",
    "phone" => "0356739226"
  },
  "credentials" => {
    "token" => "A103.rHsfH5P3to...",
    "refresh_token"=> "R103.DYHqCcnXAS...",
    "expires_at" => 1472691158,
    "expires" => true
  },
  "extra" => {
    "raw_info" => {
      "payer_id" => "6ZGXTKGQ3L35N",
      "family_name" => "Smith",
      "verified" => "true",
      "name" => "John Smith",
      "account_type" => "PERSONAL",
      "given_name" => "John",
      "user_id" => "https://www.paypal.com/webapps/auth/identity/user/K43VMDJ6KaRJgMVUFRGT3hqpdnhg1tDYLmlPgxl1HRE",
      "address" => {
        "postal_code" => "W12 4LQ",
        "locality" => "Wolverhampton",
        "region" => "West Midlands",
        "country" => "GB",
        "street_address" => "1 Main Terrace"
      },
      "verified_account" => "true",
      "language" => "en_GB",
      "zoneinfo" => "America/Los_Angeles",
      "locale" => "en_GB",
      "phone_number" => "0356739226",
      "account_creation_date" => "2016-08-30",
      "email" => "john.smith@test.com",
      "age_range" => "36-40",
      "birthday" => "1975-10-10"
    }
  }
}
```

## Contributing

Log In With PayPal has been in flux since I started this project and anything that helps keep this gem up to date and tested is greatly apprecitated. Thanks for your help!

## License

Copyright (c) 2011 by veloGraf Systems

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
