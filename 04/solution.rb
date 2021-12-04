require 'pp'

input = $<.to_a.map(&:strip)

numbers = input.shift.split(',').map(&:to_i)

#bump blank row
input.shift

def get_boards(input)
  input
    .each_slice(6)
    .map{ |grid| grid[0..4] }
    .map{ |grid| grid.map{ |line| line.split(' ').map(&:to_i) } }
    .map{ |grid| grid.flatten }
end

boards = get_boards(input)

def rows(board)
  board.each_slice(5).to_a
end

def cols(board)
  rows(board).transpose
end

def mark(board, num)
  board.map{ |n| if n == num then -1 else n end }
end

def play(numbers, boards)
  numbers.each do |num|
    boards = boards.map { |board| mark(board, num) }
    boards.each do |board|
      if rows(board).any?{ |r| r.all?(-1) } || cols(board).any?{ |c| c.all?(-1) }
        return [num, board]
      end
    end
  end
end

winning_number, winning_board = play(numbers, boards)

pp winning_board.select{ |n| n != -1 }.sum * winning_number

def play_again(numbers, boards)
  winning_boards = []
  numbers.each do |num|
    boards = boards.map { |board| mark(board, num) }
    boards.each do |board|
      if rows(board).any?{ |r| r.all?(-1) } || cols(board).any?{ |c| c.all?(-1) }
        winning_boards << board
        boards = boards.reject{ |b| b == board }
        if boards.length == 0
          return [num, winning_boards.last]
        end
      end
    end
  end
end

final_number, final_board = play_again(numbers, boards)
pp final_board.select{ |n| n != -1 }.sum * final_number
