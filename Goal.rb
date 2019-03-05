require_relative "DBconect.rb"

class Goal
  def initialize(id,sql)
    @mysql_obj = sql
    @id = id
  end

  def createGoal(name_goal, value_goal, date_goal)
    @mysql_obj.query("INSERT INTO accounts (`type_account`, `name_account`, `goal_date`, `goal_balance`, `iduser`)
              VALUES ('metas', '#{name_goal}', '#{date_goal}', '#{value_goal}', '#{@id}');")
  end



end
