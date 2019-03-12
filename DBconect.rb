require "Mysql2"
require "json"

$db  = (JSON.parse(File.read('config.json')))['db']

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
