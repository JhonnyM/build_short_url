class UrlEncoderService
  ALPHABET = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join.freeze
  # Code to understand the algorithm :
  # https://stackoverflow.com/questions/742013/how-to-code-a-url-shortener

  def self.bijective_encode(i)
    return '' if i.nil?
    return ALPHABET[0] if i == 0
    s = ''
    base = ALPHABET.length
    while i > 0
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def self.bijective_decode(s)
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end
end