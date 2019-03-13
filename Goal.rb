require_relative "DBconect.rb"

class Goal
  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
    @list_goals = Array.new()
  end

  def createGoal(name_goal, value_goal, date_goal)
    @mysql_obj.query("INSERT INTO accounts (`type_account`, `name_account`, `goal_date`, `goal_balance`, `iduser`)
              VALUES ('metas', '#{name_goal}', '#{date_goal}', '#{value_goal}', '#{@id}');")
  end
  def depositGoal(id_goal,value)
    @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_goal},-#{value});")
  end
  def deleteGoal(id_goal)
    @mysql_obj.query("CALL disable_account(#{id_goal});")
  end

  def returnGoal(value)
    return @list_goals[value.to_i].to_i
  end


  def listGoal()
    count = 1
      message = ""
    @mysql_obj.query("SELECT a.idaccount, a.name_account, a.balance, a.datecreated
    FROM accounts a WHERE a.type_account = 'metas' AND a.iduser = #{@id}  AND a.status_account = 1;").each do |e|
      message = message + " #{count}.  Nombre #{e["name_account"]} Saldo #{e["balance"]} Fecha Limite #{e["goal_date"]} \n"
      @list_goals[count] = e["idaccount"].to_i
      count = count + 1

    end
    puts message
  end


end
