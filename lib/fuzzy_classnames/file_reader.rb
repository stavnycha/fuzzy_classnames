module FuzzyClassnames
  class FileReader
    attr_reader :filename

    def initialize(filename)
      @filename = "#{Dir.pwd}/#{filename}"
    end

    def klasses
      begin
        File.read(filename).split("\s")
      rescue Errno::ENOENT => e
        raise ArgumentError.new("File with given filename does not exist")
      end
    end
  end
end
