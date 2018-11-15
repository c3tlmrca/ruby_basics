goods = {}
total = 0

loop do
  puts 'Наберите стоп, когда введете весь товар.'
  print 'Введите название товара: '
  name = gets.strip
  break if name.downcase == 'стоп'

  print 'Введите цену товара: '
  price = gets.to_f
  print 'Введите количество товара: '
  amount = gets.to_f
  next puts 'Цена, кол-во не должны быть <= 0' unless (price && amount).positive?

  goods[name] = { price: price, amount: amount }
end

puts 'Ваши товары:'
goods.each do |type, info|
  item_total = info[:amount] * info[:price]
  item_total = item_total.round(2)
  printf("%s, цена: %.2f, кол-во: %.2f, сумма: %.2f \n", type, info[:price], info[:amount], item_total)
  total += item_total
end

printf("Итог: %.2f \n", total)
