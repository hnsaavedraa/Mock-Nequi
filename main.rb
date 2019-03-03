# https://www.rubydoc.info/gems/mysql2/0.5.2
require "Mysql2"  
require_relative 'Session'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "123123", :database => "mock-nequi");


# inplementacion temporal
session = Session.new(client)
puts session.registerUser("josel","josezb@correo.com","123123123")
puts session.login('josexq@correo.com', '123')
puts session.idUser
puts session.nameUser
