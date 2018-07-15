require 'sqlite3'

module Selection
  def find(*ids)
    ids.each do |id|
      unless id.is_a?(Integer) && id >= 1
        raise ArgumentError.new("IDs must be an integer and greater than or equal to 1")
      end
    end

    if ids.length == 1
      find_one(ids.first)
    else
      rows = connection.execute <<-SQL
        SELECT #{columns.join ","} FROM #{table}
        WHERE id IN (#{ids.join(",")});
      SQL

      rows_to_array(rows)
    end
  end

  def find_one(id)
    unless id.is_a?(Integer) && id >= 1
      raise ArgumentError.new("ID must be an integer and greater than or equal to 1")
    end

    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      WHERE id = #{id};
    SQL

    init_object_from_row(row)
  end

  def find_by(attribute, value)
    unless attribute.is_a?(String) && value.is_a?(String)
      raise ArgumentError.new("Attribute and/or value must be a string")
    end

    rows = connection.execute <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      WHERE #{attribute} = #{BlocRecord::Utility.sql_strings(value)};
    SQL

    rows_to_array(rows)
  end

  def take(num=1)
    unless id.is_a?(Integer) && id >= 1
      raise ArgumentError.new("Number must be an integer and greater than or equal to 1")
    end

    if num > 1
      rows = connection.execute <<-SQL
        SELECT #{columns.join ","} FROM #{table}
        ORDER BY random()
        LIMIT #{num};
      SQL

      rows_to_array(rows)
    else
      take_one
    end
  end

  def take_one
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY random()
      LIMIT 1;
    SQL

    init_object_from_row(row)
  end

  def first
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY id ASC LIMIT 1;
    SQL

    init_object_from_row(row)
  end

  def last
    row = connection.get_first_row <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      ORDER BY id DESC LIMIT 1;
    SQL

    init_object_from_row(row)
  end

  def all
    rows = connection.execute <<-SQL
      SELECT #{columns.join ","} FROM #{table};
    SQL

    rows_to_array(rows)
  end

  def find_each(options = {})
    rows = connection.execute <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      LIMIT #{options[:batch_size]} OFFSET #{options[:start]};
    SQL

    for row in rows_to_array(rows)
      yield row
    end
  end

  def find_in_batches(options = {})
    rows = connection.execute <<-SQL
      SELECT #{columns.join ","} FROM #{table}
      LIMIT #{options[:batch_size]} OFFSET #{options[:start]};
    SQL

    yield rows_to_array(rows)
  end

  private
  def init_object_from_row(row)
    if row
      data = Hash[columns.zip(row)]
      new(data)
    end
  end

  def rows_to_array(rows)
    rows.map { |row| new(Hash[columns.zip(row)]) }
  end

  def method_missing(m, *args, &block)
    if m[0..7] == "find_by_"
      attribute = m[8..-1].to_sym
      find_by(attribute, args[0])
    end
  end
end
