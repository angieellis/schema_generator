class WelcomeController < ApplicationController
  def index
    Rails.application.eager_load!
    schema = ActiveRecord::Base.descendants
    x =  Item.reflect_on_all_associations
    x.each do |i|
      p i.class
      p i["@name"]
    end
    @associations = []
    p "test"
    p schema
    schema[1..-1].map do |table|

      p table.to_s
      name = table.to_s
      attributes = table[/^\w+/]
      p attributes
      @associations << name[0] unless name[0] == "ActiveRecord"
      @tables << name unless name == "ActiveRecord"
    end
    p @associations
    p @tables
    get_tables
  end

  def get_tables
    p @tables
  end

  def format_json
    # @associations
    # @tables
  end
end
