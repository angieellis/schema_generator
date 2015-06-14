class ErdController < ApplicationController
  def get_schema
    Rails.application.eager_load!
    ActiveRecord::Base.descendants
  end

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
    column_info, columns = [], table.columns
    @table_info << { table.table_name => get_columns_info(table, columns) }
    set_primary_key(table)
  end

  def set_primary_key(table)
    if table.primary_key == "id"
      @primary_keys[table.table_name] = table.table_name.singularize + "_id"
    else
      @primary_keys[table.table_name] = table.primary_key
    end
  end

  def get_columns(table)
    table.columns
  end

  def get_columns_info(table, columns)
    columns.map {|column| get_column_detail(table, column) }
  end

  def get_column_detail(table, column)
    info = {}
    info[:name] = column.name
    info[:precision] = column.precision
    info[:limit] = column.limit
    info[:type] = column.sql_type
    info[:null] = column.null
    info[:default] = column.default
    info[:primary_key] = determine_primary_key(table, column)
    return info
  end

  def determine_primary_key(table, column)
    table.primary_key == column.name ? true : false
  end

  def get_tables_associations(table)
    associations = get_table_associations(table)
    associations.each {|association| get_association_info(table, association) }
  end

  def get_table_associations(table)
    table.reflect_on_all_associations
  end

  def get_association_info(table, association)
    determine_association(table.table_name.to_s, association.name.to_s, get_foreign_key(table.table_name.to_s, association), association)
  end

  def get_foreign_key(table_name, association)
    if association.options.key?(:foreign_key)
      return association.options[:foreign_key]
    else
      return ""
    end
  end

  def determine_association(first_table, second_table, foreign_key, association)
    second_table = determine_alias(association)
    association_type = determine_relationship(association)

    if association_type == "has_one"
      @has_one << define_has_relationship(first_table, second_table, foreign_key)
    elsif association_type == "has_many"
      @has_many << define_has_relationship(first_table, second_table, foreign_key)
    elsif association_type == "belongs_to"
      @belongs_to << define_belongs_relationship(first_table, second_table.pluralize, foreign_key)
    elsif association_type == "through"
      delegate = association.delegate_reflection
      relationship_type = determine_relationship(delegate)

      relationship = { "first_table" => first_table,
        "second_table" => second_table,
        "through" => delegate.options[:through].to_s,
        "relationship_type" => relationship_type }

      @through << relationship
    else
      @other << relationship
    end
  end

  def determine_alias(association)
    if association.options.key?(:class_name)
      return association.options[:class_name].to_s.downcase.pluralize
    else
      return association.name.to_s
    end
  end

  def define_has_relationship(first_table, second_table, foreign_key)
    foreign_key = first_table.singularize + "_id" if foreign_key == ""
    { "first_table" => first_table, "second_table" => second_table, "primary_key" => @primary_keys[first_table], "foreign_key" => foreign_key }
  end

  def define_belongs_relationship(first_table, second_table, foreign_key)
    foreign_key = @primary_keys[second_table] if foreign_key == ""
    { "first_table" => first_table, "second_table" => second_table, "primary_key" => @primary_keys[first_table], "foreign_key" => foreign_key }
  end

  def determine_relationship(association)
    association_name = association.class.to_s

    if association_name.include? "HasOne"
      return "has_one"
    elsif association_name.include? "HasMany"
      return "has_many"
    elsif association_name.include? "BelongsTo"
      return "belongs_to"
    elsif association_name.include? "Through"
      return "through"
    else
      return "other"
    end
  end

  def get_associations
    @table_classes.each {|table| get_tables_associations(table)}
  end

  def determine_join_associations
    @belongs_to.each do |belongs|
      @through.each {|thr| add_join(belongs) if join?(belongs, thr) }
    end
  end

  def join?(belongs, thr)
    belongs["first_table"] == thr["through"] && belongs["second_table"] == thr["first_table"]
  end

  def add_join(belongs)
    belongs["primary_key"] = belongs["first_table"] + "_id"
    @belongs_to_join << belongs
  end

  def assign_associations
    @table_associations = [{"has_one" => @has_one},
      {"has_many" => @has_many},
      {"belongs_to" => @belongs_to},
      {"belongs_to_join" => @belongs_to_join},
      {"other" => @other},
      { "dating" => [{"first_table" => "rob", "second_table" => "angie", "source" => "dbc", "through" => "shared nerdiness", "foreign key" => "rob's amazing cock" }] }]
  end

  def index
    @table_names, @table_info, @primary_keys = [], [], {}

    schema = get_schema
    get_tables_names(schema)
    get_tables_classes
    get_tables_info

    @has_one, @has_many, @belongs_to, @belongs_to_join, @through, @other = [], [], [], [], [], []

    get_associations
    determine_join_associations
    assign_associations

    @table_info << { "rob" => [
      { name: "rob", type: "aussy", null: false, default: "super sexy" },
      { name: "is" },
      { name: "super" },
      { name: "sexy" }
      ]}

    render json: { "tables" => @table_info, "associations" => @table_associations }
  end

  def create
    p params
  end
end
