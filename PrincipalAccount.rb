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
    @mysql_obj.query("CALL movement_account_deposit(#{@id}, #{value});")
    update_principal_value()
  end

  def retire_principal(value)
    @mysql_obj.query("CALL movement_account_deposit(#{@id}, #{value*(-1)});")
    update_principal_value()
  end
  def deposit_mattress(value)
    @mysql_obj.query("CALL movement_accounts(#{@id},account_id(#{@id}, 'colchon'),#{value*(-1)});")
    update_matrress_value()
  end

  def retire_mattress(value)
    @mysql_obj.query("CALL movement_accounts(#{@id}, account_id(#{@id},'colchon'),#{value});")
    update_matrress_value()
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
      @mysql_obj.query("CALL tranfer_to_account(account_id(#{@id}, 'ahorros'), '#{email}',#{value});")
  end






end
