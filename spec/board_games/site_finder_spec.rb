require "spec_helper"

RSpec.describe BoardGames::SiteFinder do

  let(:board_identifier) { 1902 }
  let(:bogus_board_identifier) { 999_999_999 }
  let(:site_field_names) {
    %w[
      BOARD
      SITE_NAME
      SITE_DOMAIN
    ]
  }

  describe ".find_by_board_ids" do
    def invoke!(*board_ids)
      with_vcr_cassette("site_finder-find_by_board_ids") do
        return described_class.find_by_board_ids(board_ids.flatten, field_names: site_field_names)
      end
    end

    it "returns an array of all sites that reference the board" do
      sites = invoke!(board_identifier, bogus_board_identifier)
      expect( sites.length ).to eq( 1 )
      expect( sites.first["SITE_NAME"] ).to match( /tiera/i )
    end
  end
end
