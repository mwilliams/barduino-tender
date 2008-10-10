require 'ftools'
begin
  Kernel::require "serialport"
rescue
  puts "ERROR: requires ruby-serialport, available as a ruby gem"
  exit
end

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
  @ingredients = {"vodka" => 1, "orange_juice" => 2}
  baud_rate = 9600 
  data_bits = 8
  port_str = "/dev/ttyUSB0"  #may be different for you  
  parity = SerialPort::NONE
  stop_bits = 1 
  @sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
  
  def drink(name, &block)
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
    puts "Currently pouring #{amount} ounces of #{ingredient} from pump #{@ingredients[ingredient.to_s]}"
    amount.times do
      @sp.putc @ingredients[ingredient.to_s].to_s
      sleep 2
    end
  end
end

usage unless ARGV[0]
f = File.dirname(__FILE__) + "/#{ARGV[0]}"
drink = Drink.new
drink.instance_eval(File.new(f).read, f)
