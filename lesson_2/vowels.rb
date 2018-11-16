alphabet = ('a'..'z').to_a
vowels = {}

alphabet.each_with_index do |letter, index|
  vowels[letter] = index + 1 if /[aeiou]/ =~ letter
end
