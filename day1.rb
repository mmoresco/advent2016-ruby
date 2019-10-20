require 'set'

inpt = File.read 'input1.txt'

directions = inpt.split(/,\s*/)
directions.map! { |s| [s[0], s[1..-1].to_i] }

# Part 1
ops = [
  lambda { |c, distance| [ c[0], c[1] + distance ] }, # north
  lambda { |c, distance| [ c[0] + distance, c[1] ] }, # east
  lambda { |c, distance| [ c[0], c[1] - distance ] }, # south
  lambda { |c, distance| [ c[0] - distance, c[1] ] }  # west
]

loc = [0, 0]

directions.each { |e|
  turn, distance = e
  ops = ops.rotate(turn == 'L' ? -1 : 1)
  loc = ops[0].(loc, distance)
}

puts loc[0].abs + loc[1].abs

# Part 2
ops = [
  lambda { |x, y, distance|
    y_locs = y.upto(y + distance).to_a[1..-1]
    Array.new(y_locs.length, x).zip(y_locs)
  }, # north
  lambda { |x, y, distance|
    x_locs = x.upto(x + distance).to_a[1..-1]
    x_locs.zip(Array.new(x_locs.length, y))
  }, # east
  lambda { |x, y, distance|
    y_locs = y.downto(y - distance).to_a[1..-1]
    Array.new(y_locs.length, x).zip(y_locs)
  }, # south
  lambda { |x, y, distance|
    x_locs = x.downto(x - distance).to_a[1..-1]
    x_locs.zip(Array.new(x_locs.length, y))
  }, # west
]

loc = [0, 0]
seen = Set.new
found = false

directions.each { |e|
  if found == true
      break
  end

  turn, distance = e
  ops = ops.rotate(turn == 'L' ? -1 : 1)
  locs = ops[0].(*loc, distance)

  locs.each { |l|
    if seen.include?(l.to_s)
      puts l[0].abs + l[1].abs
      found = true
      break
    end
    seen.add(l.to_s)
  }

  loc = locs[-1]
}
