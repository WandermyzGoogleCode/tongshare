require 'openssl'
require 'digest/sha2'
require 'base64'

module ThuauthHelper
  def encrypt(content, key)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.encrypt
    c.key = Digest::SHA2.hexdigest(key)
    e = c.update(content)
    e << c.final
    return Base64.encode64(e)
  end

  def decrypt(content, key)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.decrypt
    c.key = Digest::SHA2.hexdigest(key)
    d = c.update(Base64.decode64(content))
    d << c.final
    return d
  end

end
