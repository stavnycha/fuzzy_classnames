require_relative "../ext/string"
require_relative "reader"

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
      demod_klasses.select do |klass, _|
        patterns.any? do |pattern|
          match?(klass, pattern)
        end
      end.sort_by do |klass, _|
        klass
      end.map do |_, namespaced_klass|
        namespaced_klass
      end
    end

    private

    def match?(klass, pattern)
      klass_parts   = partition(klass)
      pattern_parts = partition(pattern)

      klass_parts.size.times.any? do |i|
        pattern_parts.each_with_index.all? do |slice, j|
          if slice == " "
            j > 0 && j + 1 == pattern_parts.size &&
              klass_parts[-1].end_with?(pattern_parts[j - 1])
          elsif slice.include?("*")
            start, ends = slice.split("*")

            klass_parts[i + j].to_s.start_with?(start) &&
              klass_parts[i + j].to_s.end_with?(ends.to_s)
          else
            klass_parts[i + j].to_s.start_with?(slice)
          end
        end
      end
    end

    def demod_klasses
      @demod_klasses ||= Hash[klasses.map do |klass|
        [klass.split('.')[-1], klass]
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

    # Splitting camel case string to
    # corresponding subscrings:
    #
    # FooBar: ["Foo", "Bar"]
    def partition(string)
      res = []

      string.split('').each do |letter|
        letter.lower? && letter != ' ' ? (res[-1] += letter) : (res << letter)
      end

      res
    end

    def klasses
      reader.klasses
    end

    def reader
      @reader ||= Reader.new(filename)
    end
  end
end
