puts 'deleting data'
User.destroy_all
Course.destroy_all
puts 'delete complted'
puts ''

puts 'creating drivers'
fake_driver = User.create(first_name: 'Fake', last_name: 'Driver', phone: '0600000000', password: 'fakedriver', driver: true, country_code: '212')
driver = User.create(first_name: 'Simo', last_name: 'Hamid', phone: '0612345678', password: 'driverpass', driver: true, country_code: '212')

puts 'creating admin'
admin = User.create(first_name: 'Hassan', last_name: 'Cherradi', phone: '0661000000', password: 'adminpass', admin: true, verified: true, country_code: '212')

puts 'creating client'
client = User.create(first_name: 'Ayoub', last_name: 'Karioun', phone: '0661060260', password: 'clientpass', verified: true, country_code: '212')

# puts 'creating courses'
# Course.create(start_address: '18 rue miollis 75015', end_address: '11 rue de Javel 75015', price: 10, client: client, driver: fake_driver, status: "search")
# Course.create(start_address: '18 rue miollis 75015', end_address: '11 rue de Javel 75015', price: 15, client: User.first, driver: User.last, status: "search")

