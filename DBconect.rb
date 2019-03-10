require "Mysql2"
require "json"

$db     = (JSON.parse(File.read('config.json')))['db']

# class that controls the connection and queries the database
class DBconect

  def initialize()
    @mysql_obj = Mysql2::Client.new(
      username: $db['username'],
      password: $db['password'],
      host:     $db['host'],
      port:     $db['port'],
      database: $db['database']
    )
    end

  def query(query)
    @mysql_obj.query(query, cast_booleans: true)
  end

  def close_connection
    @mysql_obj.close
  end
end

# obj = DBconect.new();
#  obj.query("SELECT a.balance FROM accounts a WHERE a.iduser = 4 AND type_account = 'ahorros'").each do |d|
#
# puts d
#    end
  # results.each do |row|
  #   puts row["iduser"]
  #   puts row["name_user"]
  #   puts row["email"]
  #   puts row["pass"]
  #
  #   if row["dne"]  # non-existant hash entry is nil
  #     puts row["dne"]
  #   end
  # end
