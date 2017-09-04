#!/usr/local/bin/ruby

require_relative "shamwow"
require "test/unit"
require 'digest'

class TestShamwow < Test::Unit::TestCase

  @@preamble = "We the People of the United States, in Order to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty to ourselves and our Posterity, do ordain and establish this Constitution for the United States of America."
  @@gettysburg = "Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate -- we can not consecrate -- we can not hallow -- this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us -- that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion -- that we here highly resolve that these dead shall not have died in vain -- that this nation, under God, shall have a new birth of freedom -- and that government of the people, by the people, for the people, shall not perish from the earth."

  def test_ror
    assert_equal(0, ror(0, 0))
    assert_equal(0x80000000, ror(1, 1))
    assert_equal(0x80000001, ror(3, 1))
    assert_equal("00111111111111111111111111111111".to_i(2), ror("01111111111111111111111111111110".to_i(2), 1))
    assert_equal("01111111111111111111111111111111".to_i(2), ror("11111111111111111111111111111110".to_i(2), 1))
    assert_equal("10111111111111110111111111111111".to_i(2), ror("11111111111111011111111111111110".to_i(2), 2))
    assert_equal("11111111111111011111111111111110".to_i(2), ror("11111111111111011111111111111110".to_i(2), 32))
    assert_equal("11111111111111111111111111111110".to_i(2), ror("011111111111111111111111111111101".to_i(2), 1))
  end

  def test_lor
    assert_equal(0, lor(0, 0))
    assert_equal(2, lor(1, 1))
    assert_equal(6, lor(3, 1))
    assert_equal("00000000000000000000000000000010".to_i(2), lor("00000000000000000000000000000001".to_i(2), 1))
    assert_equal("10000000000000000000000000000010".to_i(2), lor("01000000000000000000000000000001".to_i(2), 1))
    assert_equal("00000000000000000000000000000101".to_i(2), lor("01000000000000000000000000000001".to_i(2), 2))
    assert_equal("11111111111111011111111111111110".to_i(2), lor("11111111111111011111111111111110".to_i(2), 32))
    assert_equal("11111111111111111111111111111011".to_i(2), lor("011111111111111111111111111111101".to_i(2), 1))
    assert_equal("11111111111111111111111111111011".to_i(2), lor("111111111111111111111111111111101".to_i(2), 1))
  end

  def test_sha2
    assert_equal(Digest::SHA2.hexdigest(''), sha2(""))
    assert_equal(Digest::SHA2.hexdigest('abc'), sha2("abc"))
    assert_equal(Digest::SHA2.hexdigest("上一页"), sha2("上一页"))
    assert_equal(Digest::SHA2.hexdigest("😀"), sha2("😀"))
    assert_equal(Digest::SHA2.hexdigest("ЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя"), sha2("ЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюя"))
    assert_equal(Digest::SHA2.hexdigest("𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌"), sha2("𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌"))

    assert_equal(Digest::SHA2.hexdigest(@@preamble), sha2(@@preamble))
    assert_equal(Digest::SHA2.hexdigest(@@gettysburg), sha2(@@gettysburg))
  end

  def test_sha1
    assert_equal(Digest::SHA1.hexdigest(''), sha1(''))
    assert_equal(Digest::SHA1.hexdigest('abc'), sha1('abc'))
    assert_equal(Digest::SHA1.hexdigest("𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌"), sha1("𝕿𝖍𝖊 𝖖𝖚𝖎𝖈𝖐 𝖇𝖗𝖔𝖜𝖓 𝖋𝖔𝖝 𝖏𝖚𝖒𝖕𝖘 𝖔𝖛𝖊𝖗 𝖙𝖍𝖊 𝖑𝖆𝖟𝖞 𝖉𝖔𝖌"))

    assert_equal(Digest::SHA1.hexdigest(@@preamble), sha1(@@preamble))
    assert_equal(Digest::SHA1.hexdigest(@@gettysburg), sha1(@@gettysburg))
  end

end