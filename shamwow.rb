#!/usr/local/bin/ruby

def chunker(string, chunk_size)
  return (string.length / chunk_size).times.collect { |i| string[i * chunk_size, chunk_size] }
end

# treat all numbers as if they are 32-bit integers
def ror(num, shift)
  (((num >> shift) | (num << (32-shift))) & ((2 ** 32) - 1))
end

def lor(num, shift)
  (((num << shift) | (num >> (32-shift))) & ((2 ** 32) - 1))
end

def sha2(message)
  
  # Implementation taken from https://en.wikipedia.org/wiki/SHA-2#Pseudocode
  message_in_bits = message.unpack("B*")[0]
  
  # first 32 bits of the fractional parts of the square roots of the first 8 primes 2 through 19:
  h0 = 0x6a09e667
  h1 = 0xbb67ae85
  h2 = 0x3c6ef372
  h3 = 0xa54ff53a
  h4 = 0x510e527f
  h5 = 0x9b05688c
  h6 = 0x1f83d9ab
  h7 = 0x5be0cd19

  # first 32 bits of the fractional parts of the cube roots of the first 64 primes 2 through 311:
  k = [
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    ]

  len = message_in_bits.length
  bits = message_in_bits
  bits << "1"
  bits << "0" * (512 - ((bits.length + 64) % 512))
  bits << "%064b" % len

  chunked = chunker(bits, 512)

  i = 0
  while i < chunked.length
    m = []

    message = chunker(chunked[i], 32)
    message.each_with_index { |word, index| m[index] = word.to_i(2) } # here's where we pass from strings of 1s and 0s back to numbers

    (16..63).each { |word|
      s0 = ror(m[word-15], 7) ^ ror(m[word-15], 18) ^ (m[word-15] >> 3)
      s1 = ror(m[word-2], 17) ^ ror(m[word-2],  19) ^ (m[word-2] >> 10)
      m[word] = (m[word-16] + s0 + m[word-7] + s1) & 0xFFFFFFFF
    }

    a = h0
    b = h1
    c = h2
    d = h3
    e = h4
    f = h5
    g = h6
    h = h7

    (0..63).each { |word|
      s1 = ror(e, 6) ^ ror(e, 11) ^ ror(e, 25)
      ch = (e & f) ^ (~(e) & g)
      temp1 = (h + s1 + ch + k[word] + m[word]) & 0xFFFFFFFF

      s0 = ror(a, 2) ^ ror(a, 13) ^ ror(a, 22)
      maj = (a & b) ^ (a & c) ^ (b & c)
      temp2 = (s0 + maj) & 0xFFFFFFFF

      h = g
      g = f
      f = e
      e = (d + temp1) & 0xFFFFFFFF
      d = c
      c = b
      b = a
      a = (temp1 + temp2) & 0xFFFFFFFF
    }

    h0 = (h0 + a) & 0xFFFFFFFF
    h1 = (h1 + b) & 0xFFFFFFFF
    h2 = (h2 + c) & 0xFFFFFFFF
    h3 = (h3 + d) & 0xFFFFFFFF
    h4 = (h4 + e) & 0xFFFFFFFF
    h5 = (h5 + f) & 0xFFFFFFFF
    h6 = (h6 + g) & 0xFFFFFFFF
    h7 = (h7 + h) & 0xFFFFFFFF

    i = i + 1
  end

  ("%08x" % h0).concat("%08x" % h1).concat("%08x" % h2).concat("%08x" % h3).concat("%08x" % h4).concat("%08x" % h5).concat("%08x" % h6).concat("%08x" % h7)
end

def sha1(message)

  message_in_bits = message.unpack("B*")[0]

  h0 = 0x67452301
  h1 = 0xEFCDAB89
  h2 = 0x98BADCFE
  h3 = 0x10325476
  h4 = 0xC3D2E1F0

  len = message_in_bits.length

  bits = message_in_bits
  bits << "1"
  bits << "0" * (512 - ((bits.length + 64) % 512))
  bits << "%064b" % len

  chunked = chunker(bits, 512)

  i = 0
  while i < chunked.length
    m = []

    message = chunker(chunked[i], 32)

    message.each_with_index { |word, index| m[index] = word.to_i(2) }

    (16..79).each { |word|
      m[word] = lor((m[word-3] ^ m[word-8] ^ m[word-14] ^ m[word-16]), 1)
    }

    a = h0
    b = h1
    c = h2
    d = h3
    e = h4

    (0..79).each { |word|
      if (0..19).include? word
        f = ((b & c) | (~b & d))
        k = 0x5A827999
      end
      if (20..39).include? word
        f = (b ^ c ^ d)
        k = 0x6ED9EBA1
      end
      if (40..59).include? word
        f = (b & c) | (b & d) | (c & d) 
        k = 0x8F1BBCDC
      end
      if (60..79).include? word
        f = (b ^ c ^ d)
        k = 0xCA62C1D6
      end

      temp = (lor(a, 5) + f + e + k + m[word]) & 0xFFFFFFFF
      e = d
      d = c
      c = lor(b, 30)
      b = a
      a = temp
    }

    h0 = (h0 + a) & 0xFFFFFFFF
    h1 = (h1 + b) & 0xFFFFFFFF
    h2 = (h2 + c) & 0xFFFFFFFF
    h3 = (h3 + d) & 0xFFFFFFFF
    h4 = (h4 + e) & 0xFFFFFFFF

    i = i + 1
  end

  ("%08x" % h0).concat("%08x" % h1).concat("%08x" % h2).concat("%08x" % h3).concat("%08x" % h4)
end