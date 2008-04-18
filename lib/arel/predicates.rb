module Arel
  class Predicate
    def ==(other)
      self.class == other.class
    end
  end

  class Binary < Predicate
    attr_reader :operand1, :operand2

    def initialize(operand1, operand2)
      @operand1, @operand2 = operand1, operand2
    end

    def ==(other)
      super and @operand1 == other.operand1 and @operand2 == other.operand2
    end
    
    def bind(relation)
      self.class.new(operand1.bind(relation), operand2.bind(relation))
    end
    
    def to_sql(formatter = nil)
      "#{operand1.to_sql} #{predicate_sql} #{operand1.format(operand2)}"
    end
  end

  class Equality < Binary
    def ==(other)
      self.class == other.class and
        ((operand1 == other.operand1 and operand2 == other.operand2) or
         (operand1 == other.operand2 and operand2 == other.operand1))
    end

    def predicate_sql
      operand2.equality_predicate_sql
    end
  end

  class GreaterThanOrEqualTo < Binary
    def predicate_sql; '>=' end
  end

  class GreaterThan < Binary
    def predicate_sql; '>' end
  end

  class LessThanOrEqualTo < Binary
    def predicate_sql; '<=' end
  end

  class LessThan < Binary
    def predicate_sql; '<' end
  end

  class Match < Binary
    alias_method :regexp, :operand2
  end
  
  class In < Binary
    def predicate_sql; operand2.inclusion_predicate_sql end
  end
end