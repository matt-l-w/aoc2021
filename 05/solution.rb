require 'pp'

input = $<.to_a.map(&:strip)
  .map{ |line| line
    .split(' -> ')
    .map{ |coord| coord.split(',').map{ |i| i.to_i } }
  }

def grid(size)
  grid = []
  (0..size).to_a.each do |x|
    row = []
    (0..size).to_a.each do |y|
      row[y] = 0
    end
    grid[x] = row
  end
  grid
end

def horizontal?(line)
  a = line[0]
  b = line[1]
  a[0] == b[0]
end

def vertical?(line)
  a = line[0]
  b = line[1]
  a[1] == b[1]
end

def gradient(a, b)
  ((a[1] - b[1])/(a[0] - b[0]))
end
def diagonal?(line)
  a = line[0]
  b = line[1]
  1 == gradient(a, b).abs
end

def mark(map, point)
  map[point[0]][point[1]] += 1
end
def mark_map(map, lines)
  lines.each do |line|
    a = line[0]
    b = line[1]
    if horizontal?(line)
      x = a[0]
      path = [a[1], b[1]].sort
      (path[0]..path[1]).to_a.each do |y|
        mark(map, [x, y])
      end
    elsif vertical?(line)
      y = a[1]
      path = [a[0], b[0]].sort
      (path[0]..path[1]).to_a.each do |x|
        mark(map, [x, y])
      end
    elsif gradient(a, b) == 1
      x1, y1, x2, y2 = [a, b].sort_by(&:first).flatten
      until x1 > x2
        mark(map, [x1, y1])
        x1+=1
        y1+=1
      end
    elsif gradient(a, b) == -1
      x1, y1, x2, y2 = [a, b].sort_by(&:first).flatten
      until x1 > x2
        mark(map, [x1, y1])
        x1+=1
        y1-=1
      end
    end
  end
end

size = input.flatten.max
first_map = grid(size)
h_or_v_lines = input.select{ |line| horizontal?(line) || vertical?(line) }
mark_map(first_map, h_or_v_lines)

pp first_map.flatten.count{ |x| x >= 2 }

second_map = grid(size)
mark_map(second_map, input)
pp second_map.flatten.count{ |x| x >= 2 }
