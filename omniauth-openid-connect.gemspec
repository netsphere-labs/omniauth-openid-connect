# -*- coding:utf-8 -*-
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)  # Better then __FILE__
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/openid_connect/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-openid-connect'
  spec.version       = OmniAuth::OpenIDConnect::VERSION
  spec.authors       = ['Hisashi Horikawa', 'Paul Scarrone',
                        'John Bohn', 'Ilya Shcherbinin']
  spec.email         = ['hisashi.horikawa@gmail.com', 'paul.scarrone@gmail.com',
                        'jjbohn@gmail.com', 'm0n9oose@gmail.com']
  spec.summary       = %q{OpenID Connect Strategy MK2 for OmniAuth}
  spec.description   = %q{OpenID Connect Strategy MK2 for OmniAuth which is fully compliant with Devise and Rails and currently maintained. Derived from jjbohn's work which is not actively maintained}
  spec.homepage      = 'https://github.com/netsphere-labs/omniauth-openid-connect'
  spec.license       = 'MIT'

  # v2.3 は 2019-03-31 EOL.
  spec.required_ruby_version = '>= 2.7'
  
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

=begin
  このパッケージは, これらと同時に使われるのが考えられる;
    - omniauth-facebook
    - omniauth-paypal-oauth2   # omniauth-paypal は古い.
      https://rubygems.org/gems/omniauth-paypal-oauth2/

    omniauth-facebook (4.0.0)    v5.0.0
      omniauth-oauth2 (~> 1.2)     ~> 1.2
    omniauth-oauth2 (1.4.0)      v1.6.0
      oauth2 (~> 1.0)              ~> 1.1
      omniauth (~> 1.2)            ~> 1.9
    openid_connect (1.1.3)
      activemodel
      attr_required (>= 1.0.0)
      json (>= 1.4.3)
      json-jwt (>= 1.5.0)
      rack-oauth2 (>= 1.6.1)
      swd (>= 1.0.0)
      tzinfo
      validate_email
      validate_url
      webfinger (>= 1.0.1)
    omniauth (1.6.1)               v1.9.0
      hashie (>= 3.4.6, < 3.6.0)       < 3.7.0, >= 3.4.6
      rack (>= 1.6.2, < 3)             < 3, >= 1.6.2
=end
  
  # symbolize_keys() 
  #spec.add_dependency 'activesupport', '>= 4.2'
  
  spec.add_dependency 'omniauth', '~> 2.0'   # omniauth-oauth2 に合わせる
  spec.add_dependency 'openid_connect', '~> 1.2'
  # CVE-2019-18848 fix.
  spec.add_dependency 'json-jwt', '>= 1.11.0'

  # A replacement for the URI implementation that is part of Ruby's standard
  # library.
  # LICENSE: APACHE-2.0 
  #spec.add_dependency 'addressable', '~> 2.5'   # 実際には使っていない

  # 'jwt' と 'json-jwt' があるが, 'jwt' が多数派.
  # jwt 2.0.0 が出ているが, oauth2 1.4.0 depends on jwt ~> 1.0
  #                        'oauth2' v1.4.1 depends on jwt<3.0, >=1.0
  # decoded_segments() が jwt v2.0.0 で削除されている。
  #spec.add_dependency 'jwt', '~> 1.5.6'

  #spec.add_development_dependency 'bundler', '~> 1.5'

  # 'coveralls' v0.8.21 depends on simplecov ~> 0.14.1
  # coverall v0.8.22 depends on simplecov ~> 0.16.1
  #spec.add_development_dependency 'coveralls'

  # simplecov, rubocop, i18n のバージョンを限定
  spec.add_development_dependency 'faker', '~> 2.19'

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-minitest'

  # Ruby 2.2からバンドルされる. gem依存不要
  #spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'

  spec.add_development_dependency 'rake'
  # mocha が制約
  spec.add_development_dependency 'rubocop', '<= 0.58.2'

  spec.add_development_dependency 'simplecov' #, '~> 0.16.1'
end
