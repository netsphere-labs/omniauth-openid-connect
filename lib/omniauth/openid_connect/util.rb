# -*- coding:utf-8 -*-

module OmniAuth
  module OpenIDConnect

    def self.hash_deep_check(this_hash, other_hash)
      raise TypeError if !other_hash.is_a?(Hash)
    
      other_hash.each_pair do |k, v|
        key = k.to_sym
        raise ArgumentError, "unknown key: #{k}" if !this_hash.key?(key)

        # thisがハッシュでないときは、vは単に値としてのハッシュ.
        if this_hash[key].is_a?(Hash) && v.is_a?(Hash)
          hash_deep_check(this_hash[key], v)
        end
      end
    end

  
    # @param [String or Hash] key_or_hash  PEM形式の証明書データ
    # @raise [OpenSSL::X509::CertificateError] 証明書のフォーマットが不正
    def self.parse_x509_key key_or_hash, kid
      raise TypeError if !key_or_hash.is_a?(String) && !key_or_hash.is_a?(Hash)
      
      if key_or_hash.is_a?(Hash)
        # https://www.googleapis.com/oauth2/v1/certs format
        raise TypeError if !kid
        key_or_hash.each do |key, pem|
          if key == kid
            return OpenSSL::X509::Certificate.new(pem).public_key
          end
        end
        raise ArgumentError, "missing kid: #{kid}"
      else
        return OpenSSL::X509::Certificate.new(key_or_hash).public_key
      end
    end


    # Decode JSON Web Key (JWK) or JWK Set format.
    # See RFC 7517
    # @param [String or Hash] key_or_hash JSON形式の文字列, またはハッシュ.
    #        Sample: https://www.googleapis.com/oauth2/v3/certs
    def self.parse_jwk_key key_or_hash, kid
      if key_or_hash.is_a?(String)
        json = JSON.parse(key_or_hash)
      elsif key_or_hash.is_a?(Hash)
        json = key_or_hash
      else
        raise TypeError, "key was #{key_or_hash.class}, #{key_or_hash.inspect}"
      end

      if json.has_key?('keys')
        return JSON::JWK::Set.new json['keys']
      else
        return JSON::JWK.new json
      end
    end


    # access token を id_token によって 検証 (validation) する.
    def self.verify_access_token(access_token, decoded_id_token, raw_id_token)
      raise TypeError if !access_token.is_a?(String)
      raise TypeError if !raw_id_token.is_a?(String)

      # If error, JSON::JWT::InvalidFormat
      jwt = JSON::JWT.decode raw_id_token, :skip_verification
      hash_length = jwt.alg[2, 3].to_i
      if decoded_id_token.at_hash !=
                             left_half_hash_of(access_token, hash_length)
        raise "invalid access_token!!: id_token.at_hash, left_half_hash = " +
              decoded_id_token.at_hash + ", " + left_half_hash_of(access_token, hash_length)
      end
    end
    
  end # module OpenIDConnect
end
