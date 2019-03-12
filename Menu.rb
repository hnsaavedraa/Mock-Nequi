require_relative "DBconect.rb"
require_relative "PrincipalAccount.rb"
require_relative "Pocket.rb"
require_relative "Goal.rb"

class Menu
  attr_accessor :id
  def initialize(user,sql)
    @sql = sql
    @id = user.idUser
    @user = user
    @principal =PrincipalAccount.new(@id,@sql)
    @pockets= Pocket.new(@id,@sql)
    @goals =Goal.new(@id,@sql)

  end

  def run()

    while true

      system "clear" or system "cls"

      puts "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒" ,
           "▒▒▒▒▒ ▒             Mock-Nequi 💰💰💰            ▒ ▒▒▒▒▒" ,
           ""
      puts  "Bienvenido #{@user.nameUser}",
            "",
            "Saldo Cuenta Ahorros :#{@principal.balance_principal}",
            "Guardado en Colchon  :#{@principal.balance_mattress}",
            "",
            "Que deseas hacer?",
            "1.añadir dinero cuenta principal",
            "2.sacar dinero cuenta principal",
            "3.Enviar dinero por email a otro usuario",
            "4.Ver movimiento de la cuenta",
            "5.Ingresar a colchon",
            "6.Ingresar a bolsillos",
            "7.Ingresar a metas",
            "9.Cerrar Sesion"

      desition = gets.chomp
      case desition
      when "1"
        puts "Cuando dinero desea ingresar a la cuenta de ahorros?"
        value = gets.chomp.to_i
        @principal.deposit_principal(value)
        puts "actualmente en cuenta de ahorros: #{@principal.balance_principal}"
        gets.chomp
      when "2"
        puts "Cuando dinero desea retirar de la cuenta de ahorros?"
        value = gets.chomp.to_i
        @principal.retire_principal(value)
        puts "actualmente en cuenta de ahorros: #{@principal.balance_principal}"
        gets.chomp
      when "3"
        puts "ingresa email usuario destino"
        email = gets.chomp()
        puts "ingresa valor a depositar "
        valuedeposit = gets.chomp().to_i
        @principal.depositToUser(email,valuedeposit)

      when "4"
        @principal.movement_history()
        gets.chomp

      when "5"
        run_mattress() 
      when "6"
        run_pocket()
      when "7"
        run_goal()
      when "9"
        break
      end
    end #while principal
  end #run

  def run_mattress() 
    while true

      system "clear" or system "cls"

      puts "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒" ,
           "▒▒▒▒▒ ▒             Mock-Nequi 💰💰💰            ▒ ▒▒▒▒▒" ,
           ""
      puts  "Guardado en Colchon  :#{@principal.balance_mattress}",
            "",
            "Que deseas hacer?",
            "1.añadir dinero desde ahorros",
            "2.enviar dinero a ahorros",
            "9.volver"

      desition = gets.chomp
      case desition
      when "1"
        puts "Cuando dinero desea ingresar a colchon?"
        value = gets.chomp.to_i
        gets.chomp
      when "2"
        puts "Cuando dinero desea sacar del colchon??"
        value = gets.chomp.to_i
        gets.chomp
      when"9"
        break
      end
    end #while principal
  end # run_mattress

  def run_pocket() 
    while true

      system "clear" or system "cls"

      puts "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒" ,
           "▒▒▒▒▒ ▒             Mock-Nequi 💰💰💰            ▒ ▒▒▒▒▒" ,
           ""
      puts  "Ahora esta en tus Bolsillos",
            "*FALTA TABLA CON LOS BOLSILLOS*",
            "Que deseas hacer?",
            "1.Crear Bolsillo",
            "2.Eliminar bolsillo",
            "3.Agregar dinero a bolsillo",
            "4.retirar dinero de bolsillo",
            "5.Enviar dinero a usuario por email",
            "9.volver"

      desition = gets.chomp
      case desition
      when "1"
        puts "*logica para crear un bolsillo*"
        value = gets.chomp.to_i
        gets.chomp

      when"9"
        break
      end
    end #while principal
  end # run_pocket
  
  def run_goal() 
    while true

      system "clear" or system "cls"

      puts "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒" ,
           "▒▒▒▒▒ ▒             Mock-Nequi 💰💰💰            ▒ ▒▒▒▒▒" ,
           ""
      puts  "Ahora estas en tus metas",
            "*poner listado de metas*",
            "Que deseas hacer?",
            "1.Crear Meta",
            "2.Cerrar Meta",
            "3.Agredar dinero a meta",
            "9.volver"

      desition = gets.chomp
      case desition
      when "1"
        puts "crear meta"
        gets.chomp
      when"9"
        break
      end
    end #while principal
  end # run_goal

end # class


