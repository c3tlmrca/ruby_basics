alphabet = ('a'..'z').to_a
vowels = {}

alphabet.each.with_index(1) do |letter, index|
  vowels[letter] = index if /[aeiou]/ =~ letter
end
