require_relative "base"

module FuzzyClassnames
  class Lexer
    class Literal < Base

      def applies?(_)
        true
      end

      def match?(string, pattern)
        return false if string.end? || pattern.end?

        string  = string.current_token
        pattern = pattern.current_token

        string.start_with?(pattern)
      end
    end
  end
end
