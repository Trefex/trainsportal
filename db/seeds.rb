User.create!(email: 'trefex@gmail.com', password: 'lcsblcsb', password_confirmation: 'lcsblcsb')

Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
Item.create!(title: "Test 3478", text: "test test test")
Sunspot.session = Sunspot.session.original_session
