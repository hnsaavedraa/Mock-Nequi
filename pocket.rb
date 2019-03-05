require_relative "DBconect.rb"

class Pocket


  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
  end

  def createPocket(name_pocket)
    @mysql_obj.query("INSERT INTO accounts (`type_account`, `name_account`, `iduser`) VALUES ('bolsillos', '#{name_pocket}', '#{@id}');")
  end

  def listPocket()
@mysql_obj.query("SELECT a.idaccount, a.name_account, a.balance, a.datecreated
 FROM accounts a WHERE a.type_account = 'bolsillos' AND a.iduser = #{@id}  AND a.status_account = 1;").each do |e|

puts "id #{ e["idaccount"]} Nombre #{e["name_account"]} Saldo #{e["balance"]} "


end
  end
end
