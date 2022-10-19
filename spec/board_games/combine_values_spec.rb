# frozen_string_literal: true

RSpec.describe BoardGames::CombineValues do

  describe ".list_union" do
    it "combines two disjoint lists" do
      actual = subject.list_union([
        [ :foo,  :bar  ],
        [ :spam, :eggs ],
      ])
      expect( actual ).to eq( [ :foo, :bar, :spam, :eggs ].sort )
    end

    it "combines three disjoint lists" do
      actual = subject.list_union([
        [ :foo,  :bar   ],
        [ :spam, :eggs  ],
        [ :yak,  :bacon ],
      ])
      expect( actual ).to eq( [ :foo, :bar, :spam, :eggs, :yak, :bacon ].sort )
    end

    it "discards duplicate values" do
      actual = subject.list_union([
        [ :foo, :bar, :baz ],
        [ :foo, :bar, :yak ],
      ])
      expect( actual ).to eq( [ :foo, :bar, :baz, :yak ].sort )
    end
  end

  describe ".hash_union" do
    let(:h1) { { 123 => "123" } }
    let(:h2) { { 456 => "456" } }
    let(:h3) { { 789 => "789" } }

    it "returns the union of both maps" do
      actual = subject.hash_union( [h1, h2, h3] )
      expect( actual ).to eq(
        {
          123 => "123",
          456 => "456",
          789 => "789",
        }
      )
    end
  end

  describe ".strictest_setting" do
    let(:list_strictest_first) {
      [
        "no photos",
        "first photo",
        "all photos",
      ]
    }

    it "returns the strictest value in the provided list (part 1a)" do
      actual = subject.strictest_setting(
        [
          "all photos",
          "no photos",
        ],
        strictest_first: list_strictest_first,
      )

      expect( actual ).to eq( "no photos" )
    end

    it "returns the strictest value in the provided list (part 1b)" do
      actual = subject.strictest_setting(
        [
          "no photos",
          "all photos",
        ],
        strictest_first: list_strictest_first,
      )

      expect( actual ).to eq( "no photos" )
    end

    it "returns the strictest value in the provided list (part 2)" do
      actual = subject.strictest_setting(
        [
          "first photo",
          "all photos",
        ],
        strictest_first: list_strictest_first,
      )

      expect( actual ).to eq( "first photo" )
    end

    specify "values not on the list will be ignored (if values on the list are provided)" do
      actual = subject.strictest_setting(
        [
          "all photos",
          "no photos",
          "octopi rarely wear shoes",
        ],
        strictest_first: list_strictest_first,
      )

      expect( actual ).to eq( "no photos" )
    end

    it "returns the strictest setting if none of the provided values are on the list" do
      actual = subject.strictest_setting(
        [
          "octopi rarely wear shoes",
          "but they seem to enjoy Crocs",
        ],
        strictest_first: list_strictest_first,
      )

      expect( actual ).to eq( list_strictest_first.first )
    end
  end

  describe "status_map" do
    let(:a) {
      {
        "NEW"     => "ACTIVE",
        "PENDING" => "PENDING",
        "CLOSE"   => "SOLD",
      }
    }
    let(:b) {
      {
        "NEW"     => "PENDING",
        "PENDING" => "PENDING",
        "CLOSE"   => "SOLD",
      }
    }

    it "combines two identical maps into one" do
      actual = subject.status_map( [a, a] )
      expect( actual ).to eq( a )
    end

    it "complains to the human if the maps disagree on how to label a particular listing status" do
      actual = subject.status_map( [a, b] )
      expect( actual ).to eq(
        {
          "NEW"     => "ACTIVE + PENDING",
          "PENDING" => "PENDING",
          "CLOSE"   => "SOLD",
        }
      )
    end
  end

  describe ".first_non_default" do
    specify "when given a list with non-default values, returns the first one" do
      actual = subject.first_non_default( [ :foo, :bar, :yak ], default: :foo )
      expect( actual ).to eq( :bar )
    end

    specify "when given a list with only default values, returns the default" do
      actual = subject.first_non_default( [ :foo, :foo ], default: :foo )
      expect( actual ).to eq( :foo )
    end

    specify "when given an empty list, returns the default" do
      actual = subject.first_non_default( [], default: :foo )
      expect( actual ).to eq( :foo )
    end
  end

  describe ".min_value" do
    it "returns the smallest value in a list" do
      actual = subject.min_value( [ 5, 3, 9, 2 ] )
      expect( actual ).to eq( 2 )
    end

    it "handles nils" do
      actual = subject.min_value( [ 5, nil, 9, 2 ] )
      expect( actual ).to eq( 2 )
    end

    it "returns nil if the list is empty (except for nils, of course)" do
      actual = subject.min_value( [ nil, nil ] )
      expect( actual ).to be nil
    end
  end

  describe ".combine_strings_with_newline" do
    it "does what it says on the tin" do
      actual = subject.combine_strings_with_newline( [ "foo", "bar", "yak" ] )
      expect( actual ).to eq( "foo\nbar\nyak" )
    end

    it "strips each string" do
      actual = subject.combine_strings_with_newline( [ "  foo   ", "bar   ", " yak", "bacon" ] )
      expect( actual ).to eq( "foo\nbar\nyak\nbacon" )
    end

    it "leaves out blank strings" do
      actual = subject.combine_strings_with_newline( [ "  foo   ", "bar   ", "", "  " ] )
      expect( actual ).to eq( "foo\nbar" )
    end

  end

end
