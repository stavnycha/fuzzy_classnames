require_relative "../../lib/fuzzy_classnames/lexer"

RSpec.describe FuzzyClassnames::Lexer do
  let(:string) { "FooBarBaz" }
  let(:lexer) { described_class.new(string) }

  describe "#size" do
    it "should return amount of string tokens" do
      expect(lexer.size).to eq(3)
    end
  end

  describe "#scan" do
    before { lexer.scan }

    it "should increase current lexer position" do
      expect(lexer.pos).to eq(0)
    end

    it "should return a token on a new position" do
      expect(lexer.current_token).to eq(lexer.tokens[lexer.pos])
    end
  end

  describe "#end?" do
    context "lexer is on after last position" do
      before { lexer.pos = lexer.size }

      it "should return true" do
        expect(lexer.end?).to eq(true)
      end
    end

    context "lexer is not on last position" do
      before { lexer.pos = 0 }

      it "should return false" do
        expect(lexer.end?).to eq(false)
      end
    end
  end

  describe "#reset!" do
    before { lexer.reset! }

    it "should reset the position to -1" do
      expect(lexer.pos).to eq(-1)
    end
  end

  describe "#current_token" do
    before { lexer.pos = 1 }

    it "should return token on current position" do
      expect(lexer.current_token).to eq(lexer.tokens[lexer.pos])
    end
  end

  describe "#last" do
    it "should return last token" do
      expect(lexer.last).to eq(lexer.tokens.last)
    end
  end

  describe "#within_position" do
    let(:current_pos) { 1 }
    before { lexer.pos = current_pos }

    it "should preserve current position after block executing" do
      lexer.within_position(2) do
        lexer.scan
      end

      expect(lexer.pos).to eq(current_pos)
    end
  end

  describe "#match?" do
    ["FooBar", "FB", "F", "B"].each do |pattern|
      it "for pattern #{pattern} should return 'true'" do
        expect(lexer.match?(pattern)).to eq(true)
      end
    end

    ["A", "BF"].each do |pattern|
      it "for pattern #{pattern} should return 'false'" do
        expect(lexer.match?(pattern)).to eq(false)
      end
    end
  end
end
