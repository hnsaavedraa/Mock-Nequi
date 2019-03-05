require_relative "DBconect.rb"
require_relative "PrincipalAccount.rb"
require_relative "Pocket.rb"
require_relative "Goal.rb"
class Menu
attr_accessor :id
def initialize(id,sql)
  @sql = sql
  @id = id
  @principal =PrincipalAccount.new(@id,@sql)
  @pockets= Pocket.new(@id,@sql)
  @goals =Goal.new(@id,@sql)

end

def run()

  while (true) do
  puts "Test"
  puts "Bienvenido #{@id}"
  puts "Que deseas hacer"
  puts "1.añadir plata cuenta principal"
  puts "2.sacar plata cuenta principal"
  puts "3.añadir plata colchon"
  puts "4.sacar plata colchon"
  puts "5.crear bolsillo"
  puts "6.crear una meta"
  puts "7.mostrar bolsillos"
  puts "8 enviar dinero"

  puts "9.salir"
  desition = gets.chomp
  case desition
  when "1"
    value = gets.chomp.to_i
    @principal.deposit_principal(value)
    puts "actualmente en cuenta principal #{@principal.balance_principal}"
  when "2"
    value2 = gets.chomp.to_i
    @principal.retire_principal(value2)
    puts "actualmente en cuenta principal #{@principal.balance_principal}"

  when "3"
    value3 = gets.chomp.to_i
    @principal.deposit_mattress(value3)
    puts "actualmente en colchon #{@principal.balance_mattress}"

  when "4"
    value4 = gets.chomp.to_i
    @principal.retire_mattress(value4)
    puts "actualmente en colchon #{@principal.balance_mattress}"

  when "5"
    puts "ingresa nombre del bolsillo"
    namepocket= gets.chomp
    @pockets.createPocket(namepocket)
  when"6"
    puts "ingresa nombre de la meta"
    namegoal = gets.chomp
    puts "ingresa valor de la meta"
    valuegoal = gets.chomp.to_i
    puts "ingresa fecha limite (formato YYYY-MM-DD)"
    dategoal = gets.chomp
    @goals.createGoal(namegoal,valuegoal,dategoal)

  when "7"

    pockets.listPocket()
  when "8"
    puts "ingresa email usuario destino"
    email = gets.chomp()
    puts "ingresa valor a depositar "
    valuedeposit = gets.chomp().to_i


   @principal.depositToUser(email,valuedeposit)

  when"9"



    break
  end

  end


end


end
