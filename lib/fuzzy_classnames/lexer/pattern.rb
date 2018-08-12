require_relative "base"

module FuzzyClassnames
  class Lexer
    class Pattern < Base

      def applies?(token)
        token.include?("*")
      end

      def match?(string, pattern)
        return false if string.end? || pattern.end?

        string  = string.current_token
        pattern = pattern.current_token

        start, ends = pattern.split("*")
        string.start_with?(start) && string.end_with?(ends.to_s)
      end
    end
  end
end
