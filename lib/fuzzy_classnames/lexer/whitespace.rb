require_relative "base"

module FuzzyClassnames
  class Lexer
    class Whitespace < Base

      def applies?(token)
        token == " "
      end

      def match?(string, pattern)
        pattern.last? && string.last.end_with?(pattern.tokens[-2])
      end
    end
  end
end
