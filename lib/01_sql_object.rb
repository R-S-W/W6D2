require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if !@columns 

      col_query||= DBConnection.execute2(<<-SQL)
        SELECT * 
        FROM #{self.table_name}
      SQL
      @columns = col_query.first.map{|n| n.to_sym}
    end
    @columns
  end

  def self.finalize!

    columns.each do |col|

       define_method(col) do 
        attributes[col]
      end

      define_method("#{col}=") do |newval|
        attributes[col] = newval
      end
    end

  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize

    # ...

  end

  def self.all
    all_query ||= DBConnection.execute(<<-SQL )
      select #{table_name}.*
      from #{table_name}
    SQL
    self.parse_all(all_query)
  end

  def self.parse_all(results)
    class_list = []
    results.each do |dict|
      class_list << self.new(dict)
    end
    class_list
  end

  def self.find(id)
    find_query =DBConnection.execute(<<-SQL, id)
      select *
      from #{table_name}
      where ? = id
    SQL
    self.new(find_query.first)  unless find_query.empty?
  end

  def initialize(params = {})

    params.each do |an, v|
      if !self.class.columns.include?(an.to_sym)
        raise "unknown attribute '#{an}'"
      end
      send(an.to_s+"=", v)
        
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    col_names = columns.map(&:to_s).join(",")
    question_marks = ["?"]*columns.length
    
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
