require 'ftools'

def usage
	puts "You must specify a drink."
	exit(1)
end

class Numeric
  def ounces(ingredient)
		Drink.dispense(ingredient, self)
	end
	alias :ounce :ounces
end

class Drink
	def description(name, &block)
    puts "#{name}"
    block.call
	end
	
	def serve_in(glass)
		puts "Please use a #{glass} or one similar to it."
	end
	
	def ingredients(&block)
		block.call
	end
	
	def self.dispense(ingredient, amount)
		puts "Pouring #{amount} ounces of #{ingredient}"
	end
end

usage unless ARGV[0]
f = File.dirname(__FILE__) + "/#{ARGV[0]}"
drink = Drink.new
drink.instance_eval(File.new(f).read, f)
