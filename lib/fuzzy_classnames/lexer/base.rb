module FuzzyClassnames
  class Lexer
    class Base

      def applies?(*args)
        raise NotImplementedError
      end

      def match?(*args)
        raise NotImplementedError
      end
    end
  end
end
