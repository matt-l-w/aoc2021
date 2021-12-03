test = %w(
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
)

input_file = File.open('./input.txt', 'r')
input = input_file.readlines(chomp: true)
input_file.close

def count(lines)
  line_length = lines[0].length
  counts = *(0..line_length-1).to_a.fill(0)
  lines.each do |line|
    line.split('').each_with_index do |char, i|
      if char == "1"
        counts[i] += 1
      end
    end
  end

  counts
end

winning_count = input.length / 2
counts = count(input)

@most_common = counts.map{|c| if c>=winning_count then 1 else 0 end }.join('')
@least_common = counts.map{|c| if c<=winning_count then 1 else 0 end }.join('')
gamma = @most_common.to_i(2)
epsilon = @least_common.to_i(2) 

puts "part one: ", gamma * epsilon
puts ''

winning_count = test.length / 2
counts = count(test)
def most_common(lines, pos)
  count = lines.map{ |l| l.split('')[pos].to_i }.sum
  if count >= lines.length.to_f/2
    1
  else
    0
  end
end
def least_common(lines, pos)
  most_common(lines, pos)^0b1
end

def ox_rating(lines, i = 0)
  if lines.length == 1
    return lines[0].to_i(2)
  end

  filter = most_common(lines, i)
  filtered_lines = lines.select{ |line| line.split('')[i].to_i == filter } 
  return ox_rating(filtered_lines, i+1)
end

def co2_rating(lines, i = 0)
  if lines.length == 1
    return lines[0].to_i(2)
  end

  filter = least_common(lines, i)
  filtered_lines = lines.select{ |line| line.split('')[i].to_i == filter } 
  return co2_rating(filtered_lines, i+1)
end

puts "part two:", ox_rating(input)*co2_rating(input)
