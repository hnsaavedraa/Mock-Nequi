require_relative "Session.rb"
require_relative "DBconect.rb"
require_relative "Menu.rb"


sql =  DBconect.new();
session = Session.new(sql)
puts "Bienvenido a Mock-nequi"
puts "ingrese el comando correspondiente"
puts "1. Registro"
puts "2. Iniciar Sesion"
input = gets.chomp()
case input
when "1"
  puts "Ingrese su nombre completo"
  name = gets.chomp()
  puts "Ingrese Correo Electronico "
  email = gets.chomp()
  puts "Ingrese Contraseña "
  pass = gets.chomp()
  session.registerUser(name, email, pass)
  session.login(email, pass)
  menu = Menu.new(session,sql)
  menu.run()

when "2"
  puts "Ingrese Correo Electronico "
  email = gets.chomp()
  puts "Ingrese Contraseña "
  pass = gets.chomp()
  result = session.login(email, pass)
  if session.idUser == nil
    puts result
  else 
    menu = Menu.new(session,sql)
    menu.run()
  end
end
