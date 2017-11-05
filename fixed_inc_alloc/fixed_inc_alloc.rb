$INPUT_DIR = "./input/input"
$OUTPUT_DIR = "./output/output"

def allocation_handler(group, *args)
  # p args
  # p group
  
  total_order = group.values.inject(:+)
  
  group.each do |id, port_order|
    pps_alloc = (port_order / total_order.to_f) * args[3]
    if pps_alloc < args[1]
      if pps_alloc > (args[1] / 2)
        # p "attempt to allocate min_trade_size within defined rules"
      end
    elsif pps_alloc >= args[1]
      if pps_alloc >= port_order
        # p "allocate the portfolio_order"
      else
        # p "round down to closest tradeable_amount within defined rules or allocate nothing"
      end
    end
    
    # recalculate total_order based on the orders from remaining portfolios
    # subtract quantity of units to an order and recalc avail_units
    # recalculate pps_alloc of each portfolio awaiting allocation based on avail_units
    
    # rules:
    # only order tradeable amounts
    # each portfolio issues its own trade
    # 0 is a tradeable amount. never leave a portfolio with leftover units
      
  end
  
end

if __FILE__ == $0
  fname = $INPUT_DIR + ARGV[0].to_s + ".txt"
  
  num_portfolios, min_trade_size, incr, avail_units = 0
  group = Hash.new
  
  File.readlines(fname).each_with_index do |line, index|
    if index == 0 
      num_portfolios = line.to_i
    elsif index == 1
      tmp = line.split(' ')
      min_trade_size, incr, avail_units = tmp[0].to_i, tmp[1].to_i, tmp[2].to_i
    else
      tmp = line.split(' ')
      group[tmp.first] = tmp.last.to_i
    end
  end
  
  allocation_handler(group, num_portfolios, min_trade_size, incr, avail_units)
  
end