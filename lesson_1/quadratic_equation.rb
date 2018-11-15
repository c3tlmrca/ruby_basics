a =
  loop do
    print 'Введите коэффициент a (не равен нулю): '
    input = gets.to_f
    break input unless input.zero?
  end

print 'Введите коэффициент b: '
b = gets.to_f

print 'Введите коэффициент c: '
c = gets.to_f

dscr = b**2 - 4 * a * c

if dscr < 0
  puts 'Корней нет'
elsif dscr.zero?
  x = -b / (2.0 * a)
  printf("x = %.4f.\n", x)
else
  sqrt_dscr = Math.sqrt(dscr)
  x1 = (-b + sqrt_dscr) / (2.0 * a)
  x2 = (-b - sqrt_dscr) / (2.0 * a)
  printf("x1 = %.4f, x2 = %.4f.\n", x1, x2)
end
