test = [
  "forward 5",
  "down 5",
  "forward 8",
  "up 3",
  "down 8",
  "forward 2"
]

input_file = File.open('./input.txt', 'r')
input = input_file.readlines()
input_file.close

class Submarine
  attr_accessor :depth
  attr_accessor :position

  def initialize
    @depth = 0
    @position = 0
  end

  def forward(x)
    @position+=x
  end

  def up(x)
    @depth-=x
  end

  def down(x)
    @depth+=x
  end

  def move(instruction)
    parts = instruction.split(' ')
    message = parts[0]
    amount = parts[1].to_i
    send(message, amount)
  end
end

def part_one(input)
  submarine = Submarine.new
  input.each{ |i| submarine.move(i) }

  submarine.depth * submarine.position
end

puts part_one(input)

class SecondSubmarine
  attr_accessor :depth
  attr_accessor :position
  attr_accessor :aim

  def initialize
    @depth = 0
    @position = 0
    @aim = 0
  end

  def forward(x)
    @position+=x
    @depth+=@aim*x
  end

  def up(x)
    @aim-=x
  end

  def down(x)
    @aim+=x
  end

  def move(instruction)
    parts = instruction.split(' ')
    message = parts[0]
    amount = parts[1].to_i
    send(message, amount)
  end
end

def part_two(input)
  submarine = SecondSubmarine.new
  input.each{ |i| submarine.move(i) }

  submarine.depth * submarine.position
end

puts part_two(input)

