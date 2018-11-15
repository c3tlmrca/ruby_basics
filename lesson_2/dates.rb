day_in_months = [31, 28, 31, 30, 31, 31, 30, 31, 30, 31, 30, 31]

def leap?(year)
  true if (year % 400).zero? || (year % 4).zero? && (year % 100 != 0)
end

def valid_date?(date_array, array_months)
  month = date_array[1]
  day = date_array[0]
  true if (1..12).cover?(month) && day <= array_months[month - 1]
end

arr_date = loop do
  date = []
  puts 'Введите дату (например 13.12.1900): '
  gets.strip.gsub(/\d+/) { |num| date << num.to_i }
  next if date.length < 3
  break date if valid_date?(date, day_in_months)

  puts 'Неверная дата.'
end

day, month, year = arr_date

day_in_months[1] += 1 if leap?(year)

days_from_start = day + day_in_months.take(month).sum
puts "#{days_from_start}-й день с начала года"
