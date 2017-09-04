# SHAmwow

Sometimes you just want to understand how your hashing algorithms works, so you implement them yourself.

It should go without saying that this was just for fun, and you should never, ever, _ever_ roll your own cryptography primatives for any  purpose other than education!

## sha1

The sha1 function in `shamwow.rb` implements the SHA1 hashing function in Ruby, outputting the 160-bit hash as a hexadecimal string.

### sources

* wikipedia's pseudocode breakdown: <https://en.wikipedia.org/wiki/SHA-1#Examples_and_pseudocode>

## sha2

The sha2 function in `shamwow.rb` implements the SHA-256 hashing function in Ruby, outputting the 256-bit hash as a hexadecimal string.

### Sources

* the actual spec: <http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf>
* wikipedia's pseudocode breakdown: <https://en.wikipedia.org/wiki/SHA-2#Pseudocode>
* a JS implementation that helped as I was debugging some boneheaded mistakes: <http://www.movable-type.co.uk/scripts/sha256.html>

## Tests

`shamwow_test.rb` contains a few sanity tests for the bit-rotation functions and for the hashes themselves, testing against the output of the `Digest` gem in the standard library.

## Obligatory

[![ShamWOW](https://img.youtube.com/vi/F3lrhPeK6gU/0.jpg)](https://www.youtube.com/watch?v=F3lrhPeK6gU)

