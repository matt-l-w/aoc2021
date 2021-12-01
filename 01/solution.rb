test_lines = %w(
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
)

input_file = File.open('./input.txt', 'r')
input = input_file.readlines()
input_file.close

def count_increases(depths)
  last_reading = depths.shift
  increase_count = 0

  while depths.length > 0 do
    this_reading = depths.shift
    increase_count += 1 if this_reading.to_i > last_reading.to_i
    last_reading = this_reading
  end

  return increase_count
end


puts "Test: ", count_increases(test_lines).to_s
puts "Input: ", count_increases(input).to_s


test_lines = %w(
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
)

input_file = File.open('./input.txt', 'r')
input = input_file.readlines()
input_file.close

def count_avg_increases(depths)
  sums = []
  depths.each_cons(3) do |chunk|
    sums << chunk.map{|n| n.to_i}.reduce(:+)
  end
  count_increases(sums)
end

puts "Test: ", count_avg_increases(test_lines).to_s
puts "Input: ", count_avg_increases(input).to_s
