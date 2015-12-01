module FileEncrypter
  class Client 
    def initialize(options = {})
      raise FileEncrypterError unless options[:input_file] && options[:key] 
      options = defaults.merge(options)

      @input_file = FileWrapper.new(file: options[:input_file], chunk_size: options[:chunk_size])
      @output_file = FileWrapper.new(file: options[:output_file], chunk_size: options[:chunk_size])
      @strategy = options[:strategy].send(:new, options[:key]) 
    end

    def encrypt!
      input_file.each_chunk do |chunk, idx, last_idx|
        encrypted_chunk = strategy.encrypt(chunk)    
        if idx != last_idx 
          encrypted_chunk << ',' 
        end
        output_file.write(encrypted_chunk)
      end

      output_file.file
    end

    def decrypt!
      input_file.split(',') do |segment|
        output_file.write(strategy.decrypt(segment))
      end
    end

    private

    attr_reader :strategy, :input_file, :output_file
    
    def defaults
      {
        :strategy => Libsodium,
        :chunk_size => nil,
        :output_file => "encrypted-output-#{SecureRandom.hex(10)}"
      }    
    end
  end
end
