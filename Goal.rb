require_relative "DBconect.rb"

class Goal
  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
    @list_goals = Array.new()
    @max_goals = Array.new()
    @balance_goals = Array.new()

  end

  def createGoal(name_goal, value_goal, date_goal)
    @mysql_obj.query("INSERT INTO accounts (`type_account`, `name_account`, `goal_date`, `goal_balance`, `iduser`)
              VALUES ('metas', '#{name_goal}', '#{date_goal}', '#{value_goal}', '#{@id}');")
  end


  def depositGoal(id_goal,value,source,max,balance)

    if(balance > max)
      puts "Felicidades,ha completado su meta"
      puts "Ya no podra ingresar mas dinero a esta meta"
      puts "Proceda a borrarla para hacer disponible su dinero"
    elsif (value.to_i > 0 && source.to_i >= value.to_i  && balance < max)
      @mysql_obj.query("CALL movement_accounts(#{@id}, #{id_goal},-#{value});")
    elsif(source.to_i <  value.to_i)
      puts "Lo sentimos, no posee esa cantidad en su cuenta. "
      puts "Actualmente en cuenta de ahorros: #{source}"

  else
    puts "Formato de entrada incorrecto"
    puts "Recuerda: El valor debe ser un numero sin comas o puntos "
    puts "y el valor minimo a retirar es de $1"
  end
  end

  def deleteGoal(id_goal)
    @mysql_obj.query("CALL disable_account(#{id_goal});")
  end

  def returnGoal(value)
    return @list_goals[value.to_i].to_i
  end

  def returnmaxGoal(value)
    return @max_goals[value.to_i].to_i
  end

  def returnbalanceGoal(value)
    return @balance_goals[value.to_i].to_i
  end


  def listGoal()
    count = 1
      message = ""
    @mysql_obj.query("SELECT a.idaccount, a.name_account, a.balance, a.goal_balance, a.goal_date
    FROM accounts a WHERE a.type_account = 'metas' AND a.iduser = #{@id}  AND a.status_account = 1;").each do |e|
      message = message + " #{count.to_s.rjust(3)} | #{e["name_account"].ljust(25)} |  #{e["balance"].to_s.rjust(12)}  | #{e["goal_balance"].to_s.rjust(12)} | #{e["goal_date"]} |\n"
      @list_goals[count] = e["idaccount"].to_i
      @max_goals[count]= e["goal_balance"].to_i
      @balance_goals[count]= e["balance"].to_i
      count = count + 1

    end
    puts "  id |     Nombre Meta           |     abonado    |  Valor meta  |   Limite   |",
         "-----┼---------------------------┼----------------┼--------------┼------------┼",
         message
  end


end
