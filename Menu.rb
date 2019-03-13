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
            "Bolsillos actuales :"
            @pockets.listPocket()
            puts"Que deseas hacer?",
            "1.Crear Bolsillo",
            "2.Eliminar bolsillo",
            "3.Agregar dinero a bolsillo",
            "4.retirar dinero de bolsillo",
            "5.Enviar dinero a usuario por email",
            "6.volver"

      desition = gets.chomp
      case desition
      when "1"
        puts "ingresa nombre del bolsillo"
  namepocket= gets.chomp
  @pockets.createPocket(namepocket)
        @pockets.listPocket()
when"2"
  puts "Ingresa el numero del bolsillo que deseas eliminar"
  @pockets.listPocket()
  todelete = gets.chomp().to_i
  @pockets.deletePocket(@pockets.returnpocket(todelete))


when"3"
  puts "Ingresa el numero del bolsillo al que deseas agregar dinero"
  @pockets.listPocket()
  pockettarget = gets.chomp()
  puts "Ingresa el monto a depositar"
  value = gets.chomp()
  @pockets.depositPocket(@pockets.returnpocket(pockettarget),value)


when"4"

  puts "Ingresa el numero del bolsillo del que deseas retirar dinero"
  @pockets.listPocket()
  pockettarget = gets.chomp().to_i
  puts "Ingresa el monto a retirar"
  value = gets.chomp().to_i
  @pockets.retirePocket(@pockets.returnpocket(pockettarget).to_i,value)

when"5"
  puts "Ingresa el numero del bolsillo del que deseas enviar dinero"
  @pockets.listPocket()
  pockettarget = gets.chomp().to_i
  puts "ingresa email usuario destino"
  email = gets.chomp()
  puts "ingresa valor a depositar "
  valuedeposit = gets.chomp().to_i
  @pockets.depositToUser(@pockets.returnpocket(pockettarget),email,valuedeposit)


when"6"
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
            "Metas actuales"
            @goals.listGoal()
      puts  "Que deseas hacer?",
            "1.Crear Meta",
            "2.Cerrar Meta",
            "3.Agregar dinero a meta",
            "9.volver"

      desition = gets.chomp
      case desition
      when "1"
        puts "ingresa nombre de la meta"
        namegoal = gets.chomp
        puts "ingresa valor de la meta"
        valuegoal = gets.chomp.to_i
        puts "ingresa fecha limite (formato YYYY-MM-DD)"
        dategoal = gets.chomp
        @goals.createGoal(namegoal,valuegoal,dategoal)
      when "2"
        puts "Ingresa el numero de la meta que deseas eliminar"
        @goals.listGoal()
        todelete = gets.chomp().to_i
        @goals.deleteGoal(@goals.returnGoal(todelete))

      when "3"
        puts "Ingresa el numero de la meta a la que deseas agregar dinero"
        @goals.listGoal()
        goaltarget = gets.chomp().to_i
        puts "Ingresa el monto a depositar"
        value = gets.chomp().to_i
        @goals.depositGoal(@goals.returnGoal(goaltarget),value)

      when"9"
        break
      end
    end #while principal
  end # run_goal

end # class
