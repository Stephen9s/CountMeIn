# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities: City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
User.create(:username => "TheStoof",
            :email => "neyens.s@gmail.com",
            :f_name => "Stephen",
            :l_name => "Neyens",
            :gender => "M",
            :mobile_phone => 4104104104,
            :description => "Hey!",
            :dob => "1988-09-17",
            :password => "123123")
