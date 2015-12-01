require 'rbnacl'
require 'securerandom'
require 'base64'
require 'activesupport'
require 'tempfile'

module FileEncrypter
  class FileEncrypterError < StandardError
  end

  class Client 
    def initialize(options)
      raise FileEncrypterError unless options[:input_file]
      options.reverse_merge!(defaults)

      @input_file = FileWrapper.new(file: options[:input_file], chunk_size: options[:chunk_size])
      @output_file = FileWrapper.new(file: options[:output_file], chunk_size: options[:chunk_size])
      @strategy = options[:strategy]
    end

    def encrypt!
      input_file.each_chunk do |chunk, idx, total|
        encrypted_chunk = strategy.encrypt(chunk)    
        if idx + 1 != total
          encrypted_chunk << ',' 
        end
        output_file.queue_write { encrypted_chunk }
      end

      output_file.write!
      output_file.get
    end

    def decrypt!
    end

    private

    attr_reader :strategy, :input_file, :output_file
    
    def defaults
      {
        :strategy => Libsodium.new,
        :chunk_size => nil,
        :output_file => "encrypted-output-#{SecureRandom.hex(10)}"
      }    
    end

    def file_encrypt(file, dest)
      chunks_in_file.times do |n|
        chunk = file.read(meg)
        prepared_chunk = encoded_n_encrypted(chunk) << ','
        dest.write(prepared_chunk)
      end

      dest.write(encoded_n_encrypted(file.read(bytes_remaining)))
      dest.close
      file.close
    end

    def file_decrypt(file, dest)
      puts file.path
      file.each(',') do |chunk|
        dest.write(decoded_n_decrypted(chunk))
      end

      dest.close
      file.close
    end
  end

  class LibSodium 

    def encrypt(plaintext)
      encode(box.encrypt(plaintext))
    end

    def decrypt(ciphertext)
      box.decrypt(decode(ciphertext))
    end

    private

    def box
      @box ||= RbNaCl::SimpleBox.from_secret_key(key)
    end

    def key
      @key ||= RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    end

    def encode(text)
      Base64.encode64(text)
    end

    def decode(base64_text)
      Base64.decode64(base64_text)
    end
  end

  class FileWrapper 
    class << self
      def default_file    
        File.new("#{SecureRandom.hex(10)}", "rb")
      end
    end

    def initialize(options = {})
      defaults = {
        :chunk_size => nil  
        :file => FileWrapper.default_file 
      }

      options.reverse_merge!(defaults) 

      @file = options[:file]
      @chunk_size = options[:chunk_size]
    end
    
    def each_chunk
      file.open 
      
      total_chunks = chunks_in_file + 1

      if chunk_size < file_size
        chunks_in_file.times do |count| 
          yield(file.read(chunk_size), count, total_chunks)
        end
      end

      yield(file.read(bytes_remaining), (total_chunks - 1), total_chunks) 

      file.close
    end

    private 

    attr_reader :file, :chunk_size

    def file_size
      File.size(file)
    end

    def chunks_in_file
      file_size(file) / chunk_size 
    end

    def bytes_remaining
      file_size(input_file) % chunk_size
    end
  end
end

  def run
    source = File.open('Get Started with Dropbox.pdf', 'rb')
    path = "dest-#{SecureRandom.urlsafe_base64}.pdf"

    enc = File.new(path, 'wb')
    file_encrypt(source, enc)

    pt = File.new("plaintext-#{SecureRandom.urlsafe_base64}.pdf", 'wb')
    enc2 = File.open(path, 'rb')

    file_decrypt(enc2, pt) 
  end

encrypter = Encrypter.new
encrypter.run
