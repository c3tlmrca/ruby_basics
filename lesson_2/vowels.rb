alphabet = ('a'..'z').to_a
vowels = {}

alphabet.each { |letter| vowels[letter] = alphabet.index(letter) + 1 if /[aeiou]/ =~ letter }
