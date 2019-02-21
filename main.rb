# https://www.rubydoc.info/gems/mysql2/0.5.2
require "Mysql2"  

client = Mysql2::Client.new(:host => "localhost", :username => "root");
