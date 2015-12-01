require 'base64'
require 'rbnacl'
require 'securerandom'
require 'tempfile'

require_relative './strategies/libsodium'
require_relative './file_wrapper'
require_relative './client'

module FileEncrypter
  class FileEncrypterError < StandardError
  end
end
