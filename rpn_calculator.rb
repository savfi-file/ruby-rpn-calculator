class RpnCalculator
  PRECEDENCE = { '+' => 1, '-' => 1, '*' => 2, '/' => 2 }
  OPERATIONS = {
    '+' => ->(a, b) { a + b },
    '-' => ->(a, b) { a - b },
    '*' => ->(a, b) { a * b },
    '/' => ->(a, b) { a / b }
  }

  def initialize(expression)
    @expression = expression
  end

  def calc_rpn
    rpn_tokens = to_rpn
    stack = []

    rpn_tokens.each do |token|
      if token =~ /\A\d+\z/
        stack.push(token.to_f)
      elsif OPERATIONS.key?(token)
        a, b = stack.pop(2)
        stack.push(OPERATIONS[token].call(a, b))
      else
        raise ArgumentError, "不正な数式です。#{token}"
      end
    end

    stack.pop
  end

  def to_rpn
    output = []
    operators = []
    tokens = @expression.scan(/\d+|[-+*\/()]/)

    tokens.each do |token|
      if token =~ /\A\d+\z/
        output.push(token)
      elsif PRECEDENCE.key?(token)
        while !operators.empty? && PRECEDENCE.key?(operators.last) && PRECEDENCE[operators.last] >= PRECEDENCE[token]
          output.push(operators.pop)
        end
        operators.push(token)
      elsif token == '('
        operators.push(token)
      elsif token == ')'
        while !operators.empty? && operators.last != '('
          output.push(operators.pop)
        end
        operators.pop
      else
        raise ArgumentError, "不正な数式です。#{token}"
      end
    end

    while !operators.empty?
      output.push(operators.pop)
    end

    output
  end
end