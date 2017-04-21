# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.find_or_create_by(name: "Jonan Scheffler", email: "jonanscheffler@gmail.com")
Room.find_or_create_by(topic: "General", slug: "general")

10.times { Fabricate(:message, user: User.first, room: Room.first) }
