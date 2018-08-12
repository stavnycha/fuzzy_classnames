require_relative "../ext/string"
require_relative "file_reader"
require_relative "lexer"

module FuzzyClassnames
  class Finder
    attr_reader :pattern, :filename

    def initialize(pattern, filename)
      @pattern = pattern.to_s
      @filename = filename

      unless @pattern.lower? || @pattern[0].upper?
        raise ArgumentError.new("Pattern should be camel case or lowercase")
      end
    end

    def matches
      demod_klasses.select do |klassname, _|
        patterns.any? { |pattern| match?(klassname, pattern) }
      end.sort_by do |klassname, _|
        klassname
      end.map do |_, namespaced_klass|
        namespaced_klass
      end
    end

    private

    def match?(klassname, pattern)
      Lexer.new(klassname).match?(pattern)
    end

    def demod_klasses
      @demod_klasses ||= Hash[klasses.map do |klass|
        [klass.split(".")[-1], klass]
      end]
    end

    # Make sure we handle both case sensitive
    # and insensitive input
    def patterns
      @patterns ||= if pattern.downcase == pattern
        # case insensitive
        [pattern.upcase, pattern.capitalize]
      else
        [pattern]
      end
    end

    def klasses
      reader.klasses
    end

    def reader
      @reader ||= FileReader.new(filename)
    end
  end
end
