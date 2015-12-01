require 'base64'
require 'rbnacl'
require 'securerandom'
require 'tempfile'

require_relative './lib/strategies/libsodium'
require_relative './lib/file_wrapper'
require_relative './lib/client'

module FileEncrypter
  class FileEncrypterError < StandardError
  end
end
