module FileEncrypter
  class FileWrapper 
    class << self
      def default_file_name    
        "#{SecureRandom.hex(10)}"
      end
    end

    def initialize(options = {})
      defaults = {
        :chunk_size => nil,
        :file => FileWrapper.default_file_name 
      }

      options = defaults.merge(options) 
      
      set_file(options[:file])
      @chunk_size = options[:chunk_size]
    end

    attr_reader :file

    def delete!
      File.delete(file.path)
    end

    def each_chunk
      last_chunk_idx = chunks_in_file

      read do |opened_file|
        if chunk_size < file_size
          chunks_in_file.times do |count| 
            yield(opened_file.read(chunk_size), count, last_chunk_idx)
          end
        end

        yield(opened_file.read(bytes_remaining), last_chunk_idx, last_chunk_idx) 
      end
    end

    def write(string)
      File.open(file.path, 'a+b') do |f|
        f.write(string)
      end
    end

    def read
      File.open(file.path, 'rb') do |f|
        yield(f)
      end
    end

    def split(seperator)
      read do |opened_file|
        opened_file.each(seperator) { |segment| yield(segment) }  
      end
    end

    private 

    attr_reader :chunk_size, :file_size

    def set_file(target)
      if [File, Tempfile].include?(target.class)
        @file = target  
      elsif File.exist?(target)
        @file = File.open(target, 'r') { |f| set_size(f); f }
      elsif target.class == String
        @file = File.open(target, 'wb') { |f| set_size(f); f }
      else
        raise FileEncrypterError
      end
    end

    def set_size(f)
      @file_size = File.size(f) 
    end

    def chunks_in_file
      file_size / chunk_size 
    end

    def bytes_remaining
      file_size % chunk_size
    end
  end
end
