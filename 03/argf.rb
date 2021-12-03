# Pretty cool little feature of ruby
# Run this with `ruby argf.rb input.txt` and it'll split
# the contents of input.txt on newlines automatically.

report = $<.to_a.map(&:strip)

puts report[0]
