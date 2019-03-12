require_relative "DBconect.rb"

class Pocket


  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
    @list_pockets = Array.new
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
      count = count + 1

    end
    puts message
  end

def returnpocket(value)
  return @list_pockets[value.to_i].to_i
end

def deletePocket(id_pocket)
@mysql_obj.query("CALL disable_account(#{id_pocket});")
end

def depositPocket(id_pocket,value)

  @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_pocket},-#{value});")
end

def retirePocket(id_pocket,value)
  @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_pocket}, #{(value)});")
end
def depositToUser(id_pocket,email,value)
  @mysql_obj.query("CALL tranfer_to_account(#{id_pocket}, '#{email}', #{value});
")
end


end
