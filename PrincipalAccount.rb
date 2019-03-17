require_relative "DBconect.rb"


class PrincipalAccount
attr_accessor :balance_principal,:balance_mattress
  def initialize(id,mysql_obj)
    @id = id
    @mysql_obj = mysql_obj
     update_principal_value()
     update_matrress_value()
   end

  def deposit_principal(value)
    if(value > 0)
      @mysql_obj.query("CALL movement_account_deposit(#{@id}, #{value});")
        puts "Transacción exitosa"
    else
      puts "Lo sentimos, el valor a ingresar debe ser minimo $1"
    end
    update_principal_value()
    puts "Presiona cualquier tecla para continuar"

  end

  def retire_principal(value)
    if(value > 0 && value <= balance_principal)
      @mysql_obj.query("CALL movement_account_deposit(#{@id}, #{value*(-1)});")
      puts "Transacción exitosa"
    elsif( value > balance_principal)
      puts "Lo sentimos, no posee esa cantidad en su cuenta "
    else
      puts "Formato de entrada incorrecto"
      puts "Recuerda: El valor debe ser un numero sin comas o puntos "
      puts "y el valor minimo a retirar es de $1"
    end
    update_principal_value()
    puts "Presiona cualquier tecla para continuar"

  end

  def deposit_mattress(value)
    if(value > 0 && value <= balance_principal)
    @mysql_obj.query("CALL movement_accounts(#{@id},account_id(#{@id}, 'colchon'),#{value*(-1)});")
    puts "Transacción exitosa"
  elsif( value > balance_principal)
    puts "Lo sentimos, no posee esa cantidad en su cuenta "
  else
  puts "Lo sentimos, el valor a ingresar debe ser minimo $1"
  end

    update_principal_value()
    update_matrress_value()
    puts "Presiona cualquier tecla para continuar"

  end

  def retire_mattress(value)
    if(value > 0 && value <= balance_mattress )
    @mysql_obj.query("CALL movement_accounts(#{@id}, account_id(#{@id},'colchon'),#{value});")
    puts "Transacción exitosa"
  elsif( value > balance_mattress)
    puts "Lo sentimos, no posee esa cantidad en su colchon "
  else
  puts "Lo sentimos, el valor a retirar debe ser minimo $1"
  end
    update_principal_value()
    update_matrress_value()
    puts "Presiona cualquier tecla para continuar"

  end

  def update_principal_value()
    @mysql_obj.query("SELECT a.balance FROM accounts a WHERE a.iduser = #{@id} AND a.type_account = 'ahorros'").each do |row|
      @balance_principal = row["balance"]
    end
  end

  def update_matrress_value()
    @mysql_obj.query("SELECT a.balance FROM accounts a WHERE a.iduser = #{@id} AND a.type_account = 'colchon'").each do |row|
     @balance_mattress = row["balance"]
    end

  end

  def depositToUser(email,value)
    if(value > 0 && value <= balance_principal )
      @mysql_obj.query("CALL tranfer_to_account(account_id(#{@id}, 'ahorros'), '#{email}',#{value});")
      puts "Transacción exitosa"
    elsif (value > balance_principal)
      puts "Lo sentimos, no posee esa cantidad en su cuenta "
    else
      puts "Lo sentimos, el valor a retirar debe ser minimo $1"
    end
      update_principal_value()
        puts "Presiona cualquier tecla para continuar"
  end

  def movement_history()
    message = ""
    puts  "       Fecha           |         Valor     |          Saldo    |    Descripcion Operacion",
          "------------------------------------------------------------------------------------------"
        @mysql_obj.query("SELECT m.valor, m.balance, m.description, m.datecreated
          FROM movements m WHERE m.idaccount = account_id(#{@id},'ahorros') ORDER BY m.idmovements DESC LIMIT 20;").each do |row|
          message = message + " #{row["datecreated"].to_s[0..-6]}  |  #{row["valor"].to_s.rjust(15)}  |  #{row["balance"].to_s.rjust(15)}  |  #{row["description"]} \n"
        end
        puts message
  end



end
