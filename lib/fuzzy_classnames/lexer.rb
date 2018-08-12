require_relative "lexer/whitespace"
require_relative "lexer/pattern"
require_relative "lexer/literal"

module FuzzyClassnames
  class Lexer
    attr_reader :tokens, :string
    attr_accessor :pos

    def initialize(string)
      @string = string
      @tokens = tokenize(string)
      @pos = -1
    end

    def size
      @tokens.size
    end

    def scan
      @tokens[@pos += 1]
    end

    def end?
      @pos >= size
    end

    def reset!
      @pos = -1
    end

    def current_token
      @tokens[@pos]
    end

    def last
      tokens.last
    end

    def last?
      @pos + 1 == size
    end

    def within_position(pos = self.pos, &block)
      current = self.pos

      self.pos = pos

      block.call.tap do
        self.pos = current
      end
    end

    def match?(pattern)
      pattern = pattern.is_a?(Lexer) ? pattern : Lexer.new(pattern)

      return true if _match?(pattern) while scan

      false
    end

    private

    # Splitting camel case string to
    # corresponding tokens:
    #
    # FooBar: ["Foo", "Bar"]
    def tokenize(string)
      res = []

      string.split("").each do |letter|
        letter.lower? && letter != " " ? (res[-1] += letter) : (res << letter)
      end

      res
    end

    def _match?(pattern)
      within_position(pos - 1) do
        pattern.reset!

        pattern.tokens.all? do |_|
          pattern.scan && scan

          rule = rules.detect { |rule| rule.applies?(pattern.current_token) }
          rule && rule.match?(self, pattern)
        end
      end
    end

    def rules
      @rules ||= [
        Lexer::Whitespace.new,
        Lexer::Pattern.new,
        Lexer::Literal.new
      ]
    end
  end
end
