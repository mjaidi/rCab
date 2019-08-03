puts 'deleting data'
User.destroy_all
Course.destroy_all
puts 'delete complted'
puts ''

puts 'creating fake driver'
User.create(first_name: 'fake', last_name: 'driver', phone: '0600000000', password: 'fakedriver')

puts 'creating admin'
User.create(first_name: 'Ayoub', last_name: 'Karioun', phone: '0661000000', password: 'adminpass', admin: true)

puts 'creating user'
User.create(first_name: 'Ayoub', last_name: 'Karioun', phone: '0661060260', password: 'clientpass')
