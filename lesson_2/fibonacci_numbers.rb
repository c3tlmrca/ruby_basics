fibonacci_numbers = [0, 1]

loop do
  next_fibonacci_number = fibonacci_numbers[-1] + fibonacci_numbers[-2]
  break if next_fibonacci_number > 100

  fibonacci_numbers << next_fibonacci_number
end

puts fibonacci_numbers
