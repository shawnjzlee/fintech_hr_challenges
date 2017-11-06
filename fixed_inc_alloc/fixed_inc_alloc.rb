$INPUT_DIR = "./input/input"
$OUTPUT_DIR = "./output/output"

$NUM_PORTFOLIOS = 0
$MIN_TRADE_SIZE = 0
$INCR = 0
$AVAIL_UNITS = 0


def is_tradeable?(order)
  return true if (order >= $MIN_TRADE_SIZE) && ((order - $MIN_TRADE_SIZE) % $INCR == 0)
  return false
end


def allocation_handler(portfolios)
  # p args
  # p group
  
  total_order = portfolios.values.inject(:+)
  allocated = portfolios
  
  portfolios.each do |id, portfolio_order|
    alloc = 0
    pps_alloc = (portfolio_order / total_order.to_f) * $AVAIL_UNITS
    if pps_alloc < $MIN_TRADE_SIZE
      if pps_alloc > ($MIN_TRADE_SIZE / 2.0)
        # p "attempt to allocate min_trade_size within defined rules"
        if $MIN_TRADE_SIZE <= $AVAIL_UNITS && is_tradeable?(portfolio_order - $MIN_TRADE_SIZE)
          alloc = $MIN_TRADE_SIZE
        end
      end
    else
      if pps_alloc >= portfolio_order
        # p "allocate the portfolio_order"
        alloc = portfolio_order
      else
        n = pps_alloc - $MIN_TRADE_SIZE
        tradeable_amount = $MIN_TRADE_SIZE + ($INCR * n)
        
        if n >= 0 && pps_alloc == tradeable_amount
          alloc = tradeable_amount
        elsif (portfolio_order - ($MIN_TRADE_SIZE * 2)) % $INCR == 0
          min_tradeable_amount = portfolio_order - ($MIN_TRADE_SIZE * 2)
          n = n < min_tradeable_amount ? n : min_tradeable_amount
          if n >= 0
            alloc = tradeable_amount
          end
        end
        # p "round down to closest tradeable_amount within defined rules or allocate nothing"
      end
    end
    
    allocated[id] = alloc
    $AVAIL_UNITS -= alloc
    total_order -= portfolio_order
    
    # recalculate total_order based on the orders from remaining portfolios
    # subtract quantity of units to an order and recalc avail_units
    # recalculate pps_alloc of each portfolio awaiting allocation based on avail_units
    
    # rules:
    # only order tradeable amounts
    # each portfolio issues its own trade
    # 0 is a tradeable amount. never leave a portfolio with leftover units
  end
  # p allocated
  allocated
end

def print_results(allocated)
  fname = $OUTPUT_DIR + ARGV[0].to_s + ".txt"
  flag = 0
  
  File.readlines(fname).each do |line|
    key = line.split(' ').first
    value = line.split(' ').last.to_i
    
    if allocated[key] != value
      p "Expected for #{key}: #{value}. Calculated #{allocated[key]}"
      flag = 1
    end
  end
  p "Test ##{ARGV[0]} passed" if flag == 0
end

if __FILE__ == $0
  fname = $INPUT_DIR + ARGV[0].to_s + ".txt"
  
  portfolios = Hash.new
  
  File.readlines(fname).each_with_index do |line, index|
    if index == 0 
      $NUM_PORTFOLIOS = line.to_i
    elsif index == 1
      tmp = line.split(' ')
      $MIN_TRADE_SIZE, $INCR, $AVAIL_UNITS = tmp[0].to_i, tmp[1].to_i, tmp[2].to_i
    else
      tmp = line.split(' ')
      portfolios[tmp.first] = tmp.last.to_i
    end
  end
  
  allocated = allocation_handler(portfolios)
  
  print_results(allocated)
end