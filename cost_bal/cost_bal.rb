$INPUT_DIR = "./input/input"
$OUTPUT_DIR = "./output/output"

def cost_balancing(group)
  m = group.size
  total_spending = group.values.inject(:+)
  
  per_part = total_spending / m
  remainder = total_spending % per_part
  
  group.each do |key, value|
    if key == 1
      group[key] = value - (per_part + remainder)
    else
      group[key] = value - per_part
    end
  end
  
  group
end

def print_results(group)
  fname = $OUTPUT_DIR + ARGV[0].to_s + ".txt"
  flag = 0
  
  File.readlines(fname).each do |line|
    key = line.split(' ').first.to_i
    value = line.split(' ').last.to_i
    
    if group[key] != value
      p "Expected for #{key}: #{value}. Calculated #{group[key]}"
      flag = 1
    end
  end
  p "Test ##{ARGV[0]} passed" if flag == 0
end

if __FILE__ == $0
  fname = $INPUT_DIR + ARGV[0].to_s + ".txt"
  group = Hash.new
  
  File.readlines(fname).each do |line|
    key = line.split(' ').first.to_i
    value = line.split(' ').last.to_i
    
    if group.has_key?(key)
      group[key] += value
    else
      group[key] = value
    end
  end
  
  group.shift.sort
  group = cost_balancing(group)
  
  print_results(group)
end