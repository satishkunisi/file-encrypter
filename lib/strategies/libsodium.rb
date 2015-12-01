module FileEncrypter
  class Libsodium 
    def initialize(key)
      @key = key
    end

    def encrypt(plaintext)
      encode(box.encrypt(plaintext))
    end

    def decrypt(ciphertext)
      box.decrypt(decode(ciphertext))
    end

    private

    attr_reader :key

    def box
      @box ||= RbNaCl::SimpleBox.from_secret_key(key)
    end

    def encode(text)
      Base64.encode64(text)
    end

    def decode(base64_text)
      Base64.decode64(base64_text)
    end
  end
end

