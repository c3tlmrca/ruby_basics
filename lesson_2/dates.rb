day_in_months = [31, 28, 31, 30, 31, 31, 30, 31, 30, 31, 30, 31]

def leap?(year)
  (year % 400).zero? || (year % 4).zero? && (year % 100 != 0)
end

def valid_date?(date_array, array_months)
  month = date_array[1]
  day = date_array[0]
  (1..12).cover?(month) && day <= array_months[month - 1]
end

arr_date = loop do
  date = []
  print 'Введите дату с разделителями (например 13 12 1900): '
  date = gets.strip.gsub(/\d+/).map(&:to_i)
  next puts 'Неверная дата.' if date.length != 3

  day_in_months[1] += 1 if leap?(date.last)
  break date if valid_date?(date, day_in_months)

  puts 'Неверная дата.'
end

day, month = arr_date

days_from_start = day + day_in_months.take(month - 1).sum
puts "#{days_from_start}-й день с начала года"
