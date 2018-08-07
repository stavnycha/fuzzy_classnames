require_relative '../../lib/fuzzy_classnames/finder'

RSpec.describe FuzzyClassnames::Finder do
  let(:filename) { 'data/classes.txt' }
  let(:finder) do
    -> (pattern) { described_class.new(pattern, filename) }
  end

  describe '#matches' do
    {
      "Foo":    ["c.d.FooBar", "a.b.FooBarBaz"],
      "FooB":   ["c.d.FooBar", "a.b.FooBarBaz"],
      "FB":     ["c.d.FooBar", "a.b.FooBarBaz"],
      "BF":     [],
      "FoBa":   ["c.d.FooBar", "a.b.FooBarBaz"],
      "FBar":   ["c.d.FooBar", "a.b.FooBarBaz"],
      "FBar ":  ["c.d.FooBar"],
      "FBB":    ["a.b.FooBarBaz"],
      "WM":     ["codeborne.WishMaker"],
      "W*M":    ["codeborne.WishMaker"],
      "W*Mak":  ["codeborne.WishMaker"],
      "W*Mak ": [],
      "foo":    ["c.d.FooBar", "a.b.FooBarBaz"],
      "fb":     ["c.d.FooBar", "a.b.FooBarBaz"],
      "fbb":    ["a.b.FooBarBaz"],
      "FB*rB":  ["a.b.FooBarBaz"],
      "B*rBaz": ["a.b.FooBarBaz"],
      "Baz":    ["a.b.FooBarBaz"],
      "BrBaz":  [],
      "F B":    [],
      " F B":   [],
    }.each do |pattern, expected_result|
      it "finds correct match for pattern <#{pattern}>" do
        expect(finder[pattern].matches).to eq(expected_result)
      end
    end
  end
end
