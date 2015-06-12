class ErdController < ApplicationController
  def get_tables_names(schema)
    schema[1..-1].each {|table| @table_names << table.to_s }
  end

  def get_tables_classes
    @table_classes = @table_names.map {|table| get_class(table) }
  end

  def get_class(table)
    Object.const_get(table)
  end

  def get_tables_info
    @table_classes.each {|table| get_table_detail(table) }
  end

  def get_table_detail(table)
    column_info, columns = [], get_columns(table)
    @table_info << { table.table_name => get_columns_info(columns) }
  end

  def get_columns(table)
    table.columns
  end

  def get_columns_info(columns)
    columns.map {|column| get_column_detail(column) }
  end

  def get_column_detail(column)
    info = {}
    info[:name] = column.name
    info[:precision] = column.precision
    info[:limit] = column.limit
    info[:type] = column.sql_type
    info[:null] = column.null
    info[:default] = column.default
    return info
  end

  def get_tables_associations(table)
    associations = get_associations(table)
    associations.each {|association| get_association_info(table, association) }
  end

  def get_associations(table)
    table.reflect_on_all_associations
  end

  def get_association_info(table, association)
    determine_association(table.table_name.to_s, association.name.to_s, get_foreign_key(association), association)
  end

  def get_foreign_key(association)
    if association.options.key?(:foreign_key)
      return association.options[:foreign_key]
    else
      return ""
    end
  end

  def determine_association(first_table, second_table, foreign_key, association)
    relationship = define_relationship(first_table, second_table, foreign_key)
    association_name = association.class.to_s

    if association_name.include? "HasMany"
      @has_many << relationship
    elsif association_name.include? "BelongsTo"
      @belongs_to << relationship
    elsif association_name.include? "Through"
      delegate = association.delegate_reflection
      relationship_type = determine_relationship(delegate)

      relationship = { "first_table" => first_table,
        "second_table" => delegate.name.to_s,
        "through" => delegate.options[:through].to_s,
        "relationship_type" => relationship_type }

      @through << relationship
    else
      @other << relationship
    end
  end

  def define_relationship(first_table, second_table, foreign_key)
    { "first_table" => first_table, "second_table" => second_table, "foreign_key" => foreign_key }
  end

  def determine_relationship(association)
    association_name = association.class.to_s

    if association_name.include? "HasMany"
      return "has_many"
    elsif association_name.include? "BelongsTo"
      return "belongs_to"
    elsif association_name.include? "Through"
      return "through"
    else
      return "other"
    end
  end

  def index
    @table_names, @table_info = [], []

    Rails.application.eager_load!
    schema = ActiveRecord::Base.descendants

    get_tables_names(schema)
    get_tables_classes
    get_tables_info

    @has_many, @belongs_to, @through, @other = [], [], [], []

    @table_classes.each {|table| get_tables_associations(table)}
    @table_associations = [{"has_many" => @has_many},
        {"belongs_to" => @belongs_to},
        {"other" => @other}]

    @table_info << { "rob" => [
      { name: "rob", type: "aussy", null: false, default: "super sexy" },
      { name: "is" },
      { name: "super" },
      { name: "sexy" }
      ]}

    @table_associations << { "dating" => {"first_table" => "rob", "second_table" => "angie", "source" => "dbc", "through" => "shared nerdiness", "foreign key" => "rob's amazing cock" } }

    render json: { "tables" => @table_info, "associations" => @table_associations }
  end

  def create
    p params
  end
end
