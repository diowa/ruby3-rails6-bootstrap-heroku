# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create! name: 'John Doe'
project = user.projects.create! name: 'Project 1'
unit_a = project.units.create! name: 'Unit A 10 days ago'

puts "User, Project, Unit A #{Time.current.iso8601}"

sleep 3.seconds

unit_b = project.units.create! name: 'Unit B'

puts "Unit B #{Time.current.iso8601}"

sleep 3.seconds

unit_a.update! name: 'Unit A 5 days ago'

puts "Unit A updated #{Time.current.iso8601}"

sleep 3.seconds

user.update! name: 'Joe Doe'

puts "User updated #{Time.current.iso8601}"
