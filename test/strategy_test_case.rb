class StrategyTestCase < MiniTest::Test
  class DummyApp
    def call(env); end
  end

  attr_accessor :identifier, :secret, :issuer, :nonce

  def setup
    @identifier = '1234'
    @secret = '1234asdgat3'
    @issuer = "https://server.example.com"
    @nonce = SecureRandom.hex(16)
  end

  def client
    strategy.client
  end

  def payload
    {
      "iss": issuer,
      "aud": identifier,
      "sub": "248289761001",
      "nonce": nonce,
      "exp": Time.now.to_i + 1000,
      "iat": Time.now.to_i + 1000
    }
  end

  def user_info
    @user_info ||= OpenIDConnect::ResponseObject::UserInfo.new(
      sub: SecureRandom.hex(16),
      name: Faker::Name.name,
      email: Faker::Internet.email,
      email_verified: Faker::Boolean.boolean,
      nickname: Faker::Name.first_name,
      preferred_username: Faker::Internet.user_name,
      given_name: Faker::Name.first_name,
      family_name: Faker::Name.last_name,
      gender: 'female',
      picture: Faker::Internet.url + '.png',
      phone_number: Faker::PhoneNumber.phone_number,
      website: Faker::Internet.url,
    )
  end

  def request
    @request ||= stub('Request').tap do |request|
      request.stubs(:params).returns({})
      request.stubs(:cookies).returns({})
      request.stubs(:env).returns({})
      request.stubs(:scheme).returns({})
      request.stubs(:ssl?).returns(false)
    end
  end

  def strategy
    @strategy ||= OmniAuth::Strategies::OpenIDConnect.new(DummyApp.new).tap do |strategy|
      strategy.options.client_options.identifier = @identifier
      strategy.options.client_options.secret = @secret
      strategy.stubs(:request).returns(request)
      strategy.stubs(:user_info).returns(user_info)
    end
  end
end
