require 'ftools'

def usage
  puts "You must specify a drink"
  exit(1)
end

class Numeric
  def ounces
    Ingredient.new(:ounce, self)
  end
  alias :ounce :ounces
end

class String
  def ounce
    self + " ounces"
  end
end

class Ingredient
  def initialize(type, value)
    @type = type
    @value = value
  end
  def to_s
    "#{@value} #{@type}s"
  end
end

class Recipe
  attr_accessor :ingredients
  def initialize(name)
    @name = name
    @ingredients = {}
  end
end

class Context
  def desc(msg)
    puts "Preparing: #{msg}"
  end

  def recipe(name, &block)
    @recipe = Recipe.new(name)
    block.call
    @recipe
  end
  
  def ingredients(ingredients)
    puts "\nIngredients:"
    ingredients.sort.each do |k, v|
      puts " #{k}: #{v}"
    end
    @recipe.ingredients = ingredients
  end  
end

usage unless ARGV[0]
f = File.dirname(__FILE__) + "/#{ARGV[0]}"
context = Context.new
context.instance_eval(File.new(f).read, f)
