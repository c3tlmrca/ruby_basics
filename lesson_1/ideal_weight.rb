print 'Enter your name, please: '
name = gets.strip.capitalize

loop do
  print 'Enter your height: '
  height = gets.to_i

  if height <= 0
    puts 'Incorrect height!'
    next
  end

  optimal_weight = height - 110

  if optimal_weight >= 0
    puts "#{name}, your ideal weight is: #{optimal_weight}"
  else
    puts 'Your weight is optimal'
  end

  exit
end
