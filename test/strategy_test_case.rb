# -*- coding:utf-8 -*-

# Mocha の使いすぎは、テストがテストでなくなる。控え目に!

class StrategyTestCase < MiniTest::Test
  # rack app
  class DummyApp
    def call(env)
      [ 200,
        { 'Content-Type' => 'text/plain' },
        env.keys.sort.map {|k| "#{k} = #{env[k]}\n" }
      ]
    end
  end

  attr_reader :identifier, :secret

  # @override
  def setup
    @identifier = '1234'
    @secret = '1234asdgat3'
  end

  def client
    strategy.client()
  end

  def user_info
    @user_info ||= OpenIDConnect::ResponseObject::UserInfo.new(
      sub: SecureRandom.hex(16),
      name: Faker::Name.name,
      email: Faker::Internet.email,
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
    # stub Rack::Request
    @request ||= Rack::Request.new({
                   'rack.input' => '',
                   'rack.url_scheme' => 'http'})
      #request.stubs(:params).returns({})
      #request.stubs(:cookies).returns({})
      #request.stubs(:env).returns({})     set by ctor
      #request.stubs(:scheme).returns('http')
      #request.stubs(:ssl?).returns(false)
  end

  def strategy
    @strategy ||= OmniAuth::Strategies::OpenIDConnect.new(DummyApp.new).tap do |strategy|
      strategy.options.client_options.identifier = @identifier
      strategy.options.client_options.secret = @secret
      strategy.stubs(:request).returns(request)
      strategy.stubs(:user_info).returns(user_info)
      strategy.stubs(:script_name).returns('')
    end
  end
end
