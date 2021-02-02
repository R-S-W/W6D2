require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    param_str= params.keys.map {|k| "#{k} = ?"  }.join(" AND ")
    where_query = DBConnection.execute(<<-SQL, *params.values)
      SELECT *
      FROM #{self.table_name}
      WHERE #{param_str}
    SQL
    new_instance_list = []
    where_query.each do |row|
      new_instance_list << self.new(row)
    end
    new_instance_list
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
