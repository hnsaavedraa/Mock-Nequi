require_relative "DBconect.rb"

class Pocket


  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
    @list_pockets = Array.new
    @balance_pockets = Array.new
  end

  def createPocket(name_pocket)
    @mysql_obj.query("INSERT INTO accounts (`type_account`, `name_account`, `iduser`) VALUES ('bolsillos', '#{name_pocket}', '#{@id}');")
  end

  def listPocket()
    count = 1
      message = ""
    @mysql_obj.query("SELECT a.idaccount, a.name_account, a.balance, a.datecreated
    FROM accounts a WHERE a.type_account = 'bolsillos' AND a.iduser = #{@id}  AND a.status_account = 1;").each do |e|
      message = message + " #{count}.  Nombre #{e["name_account"]} Saldo #{e["balance"]} \n"
      @list_pockets[count] = e["idaccount"].to_i
      @balance_pockets[count]= e["balance"].to_i
      count = count + 1

    end
    puts message
  end

def returnpocket(value)
  if(value.to_i>0 && value.to_i <= @list_pockets.length())
    return @list_pockets[value.to_i].to_i
  end

end

def returndepositpocket(value)
  return @balance_pockets[value.to_i].to_i

end

def deletePocket(id_pocket)
@mysql_obj.query("CALL disable_account(#{id_pocket});")
end

def depositPocket(id_pocket,value,source)
if (value.to_i > 0 && source.to_i >= value.to_i )
  @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_pocket},-#{value});")
puts "Transaccion Exitosa"
elsif(source.to_i < value.to_i)
  puts "Lo sentimos, no posee esa cantidad en su cuenta. "
  puts "Actualmente en cuenta de ahorros: #{source}"
else
  puts "Formato de entrada incorrecto"
  puts "Recuerda: El valor debe ser un numero sin comas o puntos "
  puts "y el valor minimo a retirar es de $1"
end
end

def retirePocket(id_pocket,value,balance)
  if(value > 0 && value <= balance)
  @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_pocket}, #{(value)});")
  puts "Transacción exitosa"
elsif( value > balance)
  puts "Lo sentimos, no posee esa cantidad en ese bolsillo "
else
  puts "Formato de entrada incorrecto"
  puts "Recuerda: El valor debe ser un numero positivo sin comas o puntos "
  puts "y el valor minimo a retirar es de $1"
  end
end
def depositToUser(id_pocket,email,value,balance)
  if(value > 0 && value <= balance)
    @mysql_obj.query("CALL tranfer_to_account(#{id_pocket}, '#{email}', #{value});")
    puts "Transacción exitosa"
  elsif( value > balance)
    puts "Lo sentimos, no posee esa cantidad en ese bolsillo "
  else
    puts "Formato de entrada incorrecto"
    puts "Recuerda: El valor debe ser un numero positivo sin comas o puntos "
    puts "y el valor minimo a retirar es de $1"
  end
end


end
