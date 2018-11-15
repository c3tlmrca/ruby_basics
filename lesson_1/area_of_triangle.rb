loop do
  print 'Enter the base: '
  base = gets.to_f

  print 'Enter the height: '
  height = gets.to_f

  if base <= 0 || height <= 0
    puts 'Incorrect base/height'
    next
  end

  area = base * height * 0.5
  puts "The area = #{area}"

  exit
end
