# -*- coding:utf-8 -*-

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simplecov'
require 'minitest/autorun'
require 'mocha/minitest'
require 'faker'
#require 'active_support'
require 'omniauth'

#SimpleCov.command_name 'test'
SimpleCov.start do
  add_filter '/test/'
end

require 'omniauth-openid-connect'
require_relative 'strategy_test_case'

OmniAuth.config.test_mode = true
OmniAuth.config.logger = Logger.new('/dev/null')
