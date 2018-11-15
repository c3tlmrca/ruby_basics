def read_side_length(side_name)
  print "Введите сторону #{side_name}: "
  gets.to_f
end

def is_triangle?(sd_a, sd_b, sd_c)
  (sd_a < sd_b + sd_c) && (sd_b < sd_a + sd_c) && (sd_c < sd_a + sd_b)
end

def valid_lengths?(lengths)
  lengths.all? { |length| length.positive? }
end

lengths =
  loop do
    a = read_side_length(:a)
    b = read_side_length(:b)
    c = read_side_length(:c)
    break [a, b, c] if valid_lengths?([a, b, c]) && is_triangle?(a, b, c)

    puts 'Стороны <= 0, либо треугольник с такими сторонами не существует.'
  end

cat_a, cat_b, hypotenuse = lengths.sort

rigth_triangle = hypotenuse**2 == cat_a**2 + cat_b**2
right_isosceles_triangle = rigth_triangle && (cat_a == cat_b)
equilateral_triangle = (cat_a == cat_b) && (cat_b == hypotenuse)

if right_isosceles_triangle
  puts 'Это равнобедренный прямоугольный треугольник'
elsif rigth_triangle
  puts 'Это прямоугольный треугольник'
elsif equilateral_triangle
  puts 'Это равносторонний треугольник'
end
