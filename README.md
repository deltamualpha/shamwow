# SHAmwow

Sometimes you just want to understand how an algorithm works, so you implement it yourself.

The sha2 function in shamwow.rb implements the SHA-256 hashing function in Ruby. shamwow_test.rb contains a few sanity tests for the right-rotate function and for SHA2 itself, testing against the output of the `Digest::SHA2.hexdigest` method in the Ruby standard library.

It should go without saying that this was just for fun, and you should never, ever roll-your-own cryptography primatives for any reasonable purpose!

This was fun.

## Sources

* the actual spec: <http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf>
* wikipedia's pseudocode breakdown: <https://en.wikipedia.org/wiki/SHA-2#Pseudocode>
* a JS implementation that helped as I was debugging some boneheaded mistakes: <http://www.movable-type.co.uk/scripts/sha256.html>

## Obligatory

[![ShamWOW](https://img.youtube.com/vi/F3lrhPeK6gU/0.jpg)](https://www.youtube.com/watch?v=F3lrhPeK6gU)

