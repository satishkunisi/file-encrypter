A streaming file encrypter in Ruby. Built on RbNaCl. WIP.

File Encrypter uses symmetric encryption (RbNaCl's SimpleBox by default), processing 
binary files in chunks to avoid loading large files into memory during encryption.  
The FileEncrypter::Client reads the input file and encrypts each chunk (in bytes),
writing the encrypted chunks to a comma delimited base64 file on disk.    

Decryption splits the ciphertext by base64 segment, decodes and decrypts   
the ciphertext, and writes a plaintext file. 
