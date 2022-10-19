# frozen_string_literal: true

RSpec.describe BoardGames::BoardCombiner do
  subject { described_class }

  let(:board_1_status_map) {
    {
      "RENTED"                        => "SOLD",
      "BACK ON MARKET"                => "ACTIVE",
      "EXTENDED"                      => "ACTIVE",
      "CONTINGENT - CONTINUE TO SHOW" => "PENDING",
      "LEASE OPTION"                  => "ACTIVE",
      "SOLD"                          => "SOLD",
      "CLOSED (FINAL SALE)"           => "SOLD",
      "WITH-UNCONDITIONAL"            => "PENDING",
      "ACTIVE-UNDER CONTRACT"         => "ACTIVE",
      "CLOSED"                        => "SOLD",
      "WITH-CONDITIONAL"              => "PENDING",
      "ACTIVE"                        => "ACTIVE",
      "NEW"                           => "ACTIVE",
      "PRICE CHANGE"                  => "ACTIVE",
      "PENDING"                       => "PENDING",
      "LEASE"                         => "ACTIVE"
    }
  }
  let(:board1) {
    {
      "ID"                    => 489,
      "BOARD_NAME"            => "Board #102 - CRMLS",
      "LIMIT_SEARCH_CRITERIA" => {},
      "RG_BOARDS"             => [102],
      "RG_LIMIT_RESULT_COUNT" => 123,
      "SEARCH_STATUS_MAP"     => board_1_status_map,
      "ALERT_STATUS_MAP"      => board_1_status_map,
      "SOLD_WITHIN_MAX"       => 36,
      "PROPERTY_CACHE_TIME"   => 123,

      "COURTESY_OF_SHOWN_IN_GALLERY"                    => true,
      "GALLERY_BUTTONS_ON_SLIDESHOW_PHOTOS"             => true,
      "MEGA_DISCLAIMER"                                 => true,
      "RG_ENABLE_RENTALS"                               => true,
      "RG_ENABLE_VIRTUAL_TOUR"                          => true,
      "RG_HIDE_CONTACT_BUTTON_ON_PROPERTY_DETAILS_PAGE" => false,
      "RG_HIDE_REMARKS_ON_LIST_VIEW"                    => false,
      "RG_SHOW_PRICE_CHANGES"                           => true,
      "SHOW_COMPANY_STAMP"                              => true,
      "SHOW_LIST_PRICE_ON_SOLDS"                        => true,
      "SPAM_LOGO_ON_MAP_SEARCH"                         => true,
      "VALUATION_CANADA_LABELS"                         => true,
      "REG_MARK_ON_REALTOR"                             => true,
      "REG_MARK_ON_MLS"                                 => true,
      "SHOW_LIVING_AREA_SOURCE"                         => true,
      "ENABLE_CRAIGSLIST_TOOL"                          => true,
      "ENABLE_HSTS_HEADER"                              => true,
      "ENABLE_X_FRAME_OPTIONS"                          => true,

      "COURTESY_OF_PLACEMENT"                      => "bottom of page",
      "COURTESY_OF_PLACEMENT_IN_MAPSEARCH_RESULTS" => "bottom",
      "COURTESY_OF_PLACEMENT_IN_RESULTS"           => "bottom",
      "DISCLAIMER_FOOTER"                          => "footer one",
      "DISCLAIMER_PLACEMENT"                       => "bottom of page",
      "LM_AREA_ATTRS"                              => "region, community, county, city, subdivision, neighborhood",
      "LM_AREA_MAPPER"                             => "foo",
      "MAP_SEARCH_DISCLAIMER_POSITION"             => "at bottom",
      "PHOTOS_ON_SOLDS"                            => "all photos",
      "PROP_LISTINGS_FULL_DETAILS"                 => "foo",
      "PROP_LISTINGS_MAPSEARCH_DETAILS"            => "foo",
      "PROP_LISTINGS_QUICK_DETAILS"                => "foo",
      "RESIZE_THUMBNAILS_TO_FIT"                   => "width",
      "RG2_SEARCH_FIELDS"                          => "foo",
      "RG2_SEARCH_FORMS"                           => "foo",
      "RG_PROPERTY_UNIQUE_ID"                      => "foo",

      "COURTESY_OF"                 => { "489" => "disclaimer_489" },
      "DISCLAIMER_DETAIL"           => { "489" => "disclaimer_489" },
      "DISCLAIMER_RESULTS"          => { "489" => "disclaimer_489" },
      "IDX_LOGO_IN_LISTINGS"        => { "489" => "idx 489" },
      "PLASTER_MLS_LOGO_IN_DETAILS" => { "489" => "html for 489" },
      "SOLD_COURTESY_OF"            => { "489" => "disclaimer_489" },
    }
  }

  let(:board_2_status_map) {
    {
      "ACTIVE OPTION CONTRACT" => "ACTIVE",
      "ACTIVE KICK OUT"        => "ACTIVE",
      "ACTIVE CONTINGENT"      => "ACTIVE",
      "ACTIVE"                 => "ACTIVE",
      "ACTIVE UNDER CONTRACT"  => "ACTIVE",
      "PENDING"                => "PENDING"
    }
  }
  let(:board2) {
    {
      "ID"                    => 408,
      "BOARD_NAME"            => "Board #45 - NTREIS",
      "LIMIT_SEARCH_CRITERIA" => {},
      "RG_BOARDS"             => [45],
      "RG_LIMIT_RESULT_COUNT" => nil,
      "SEARCH_STATUS_MAP"     => board_2_status_map,
      "ALERT_STATUS_MAP"      => board_2_status_map,
      "SOLD_WITHIN_MAX"       => 24,
      "PROPERTY_CACHE_TIME"   => 456,

      "COURTESY_OF_SHOWN_IN_GALLERY"                    => false,
      "GALLERY_BUTTONS_ON_SLIDESHOW_PHOTOS"             => false,
      "MEGA_DISCLAIMER"                                 => false,
      "RG_ENABLE_RENTALS"                               => false,
      "RG_ENABLE_VIRTUAL_TOUR"                          => true,
      "RG_HIDE_CONTACT_BUTTON_ON_PROPERTY_DETAILS_PAGE" => false,
      "RG_HIDE_REMARKS_ON_LIST_VIEW"                    => false,
      "RG_SHOW_PRICE_CHANGES"                           => true,
      "SHOW_COMPANY_STAMP"                              => false,
      "SHOW_LIST_PRICE_ON_SOLDS"                        => true,
      "SPAM_LOGO_ON_MAP_SEARCH"                         => false,
      "VALUATION_CANADA_LABELS"                         => false,
      "REG_MARK_ON_REALTOR"                             => false,
      "REG_MARK_ON_MLS"                                 => false,
      "SHOW_LIVING_AREA_SOURCE"                         => false,
      "ENABLE_CRAIGSLIST_TOOL"                          => false,
      "ENABLE_HSTS_HEADER"                              => false,
      "ENABLE_X_FRAME_OPTIONS"                          => false,

      "COURTESY_OF_PLACEMENT"                      => "above price",
      "COURTESY_OF_PLACEMENT_IN_MAPSEARCH_RESULTS" => "top",
      "COURTESY_OF_PLACEMENT_IN_RESULTS"           => "top",
      "DISCLAIMER_FOOTER"                          => "footer two",
      "DISCLAIMER_PLACEMENT"                       => "above widgets",
      "LM_AREA_ATTRS"                              => "city",
      "LM_AREA_MAPPER"                             => "bar",
      "MAP_SEARCH_DISCLAIMER_POSITION"             => "in results list",
      "PHOTOS_ON_SOLDS"                            => "all photos",
      "PROP_LISTINGS_FULL_DETAILS"                 => "bar",
      "PROP_LISTINGS_MAPSEARCH_DETAILS"            => "bar",
      "PROP_LISTINGS_QUICK_DETAILS"                => "bar",
      "RESIZE_THUMBNAILS_TO_FIT"                   => "height",
      "RG2_SEARCH_FIELDS"                          => "bar",
      "RG2_SEARCH_FORMS"                           => "bar",
      "RG_PROPERTY_UNIQUE_ID"                      => "bar",

      "COURTESY_OF"                 => { "408" => "disclaimer_408" },
      "DISCLAIMER_DETAIL"           => { "408" => "disclaimer_408" },
      "DISCLAIMER_RESULTS"          => { "408" => "disclaimer_408" },
      "IDX_LOGO_IN_LISTINGS"        => { "408" => "idx 408" },
      "PLASTER_MLS_LOGO_IN_DETAILS" => { "408" => "html for 408" },
      "SOLD_COURTESY_OF"            => { "408" => "disclaimer_408" },
    }
  }

  let(:combined_status_map) { board_1_status_map.merge(board_2_status_map) }


  describe "#call" do
    let(:combined) { subject.new(board1, board2).call }

    it "works" do
      aggregate_failures do
        expect( combined["RG_BOARDS"]                                       ).to eq( [ 45, 102 ] )

        expect( combined["RG_SHOW_PRICE_CHANGES"]                           ).to be true
        expect( combined["RG_ENABLE_VIRTUAL_TOUR"]                          ).to be true
        expect( combined["RG_HIDE_REMARKS_ON_LIST_VIEW"]                    ).to be false
        expect( combined["SHOW_LIST_PRICE_ON_SOLDS"]                        ).to be true
        expect( combined["RG_HIDE_CONTACT_BUTTON_ON_PROPERTY_DETAILS_PAGE"] ).to be false
        expect( combined["COURTESY_OF_SHOWN_IN_GALLERY"]                    ).to be true
        expect( combined["VALUATION_CANADA_LABELS"]                         ).to be true
        expect( combined["GALLERY_BUTTONS_ON_SLIDESHOW_PHOTOS"]             ).to be false
        expect( combined["SHOW_COMPANY_STAMP"]                              ).to be false
        expect( combined["SPAM_LOGO_ON_MAP_SEARCH"]                         ).to be true
        expect( combined["MEGA_DISCLAIMER"]                                 ).to be true
        expect( combined["RG_ENABLE_RENTALS"]                               ).to be true
        expect( combined["REG_MARK_ON_REALTOR"]                             ).to be true
        expect( combined["REG_MARK_ON_MLS"]                                 ).to be true
        expect( combined["SHOW_LIVING_AREA_SOURCE"]                         ).to be true
        expect( combined["ENABLE_CRAIGSLIST_TOOL"]                          ).to be false
        expect( combined["ENABLE_HSTS_HEADER"]                              ).to be true
        expect( combined["ENABLE_HSTS_HEADER"]                              ).to be true

        expect( combined["PHOTOS_ON_SOLDS"]                            ).to eq( "all photos" )
        expect( combined["RG_PROPERTY_UNIQUE_ID"]                      ).to eq( "mls_number" )
        expect( combined["PROP_LISTINGS_QUICK_DETAILS"]                ).to eq( "beds,baths,mls,building_name,listing_office" )
        expect( combined["PROP_LISTINGS_FULL_DETAILS"]                 ).to eq( "beds,baths,br,mls,square_footage,status" )
        expect( combined["PROP_LISTINGS_MAPSEARCH_DETAILS"]            ).to eq( "beds,baths,square_footage,status" )
        expect( combined["LIMIT_SEARCH_CRITERIA"]                      ).to eq( {} )
        expect( combined["LM_AREA_ATTRS"]                              ).to eq( "region, community, county, city, subdivision, neighborhood" )
        expect( combined["RG2_SEARCH_FIELDS"]                          ).to eq( "combo_default_dont_edit.yaml" )
        expect( combined["RG2_SEARCH_FORMS"]                           ).to eq( "combo_default_dont_edit.yaml" )
        expect( combined["COURTESY_OF_PLACEMENT"]                      ).to eq( "above price" )
        expect( combined["COURTESY_OF_PLACEMENT_IN_RESULTS"]           ).to eq( "top" )
        expect( combined["COURTESY_OF_PLACEMENT_IN_MAPSEARCH_RESULTS"] ).to eq( "top" )
        expect( combined["DISCLAIMER_FOOTER"]                          ).to eq( "footer one\nfooter two" )
        expect( combined["DISCLAIMER_PLACEMENT"]                       ).to eq( "above widgets" )
        expect( combined["RESIZE_THUMBNAILS_TO_FIT"]                   ).to eq( "width" )
        expect( combined["MAP_SEARCH_DISCLAIMER_POSITION"]             ).to eq( "at bottom" )

        expect( combined["RG_LIMIT_RESULT_COUNT"] ).to eq( 123 )
        expect( combined["SOLD_WITHIN_MAX"]       ).to eq( 24 )
        expect( combined["PROPERTY_CACHE_TIME"]   ).to eq( 5 )

        expected_compliance_map = {
          "408" => "disclaimer_408",
          "489" => "disclaimer_489",
        }
        expect( combined["DISCLAIMER_DETAIL"]  ).to eq( expected_compliance_map )
        expect( combined["DISCLAIMER_RESULTS"] ).to eq( expected_compliance_map )
        expect( combined["COURTESY_OF"]        ).to eq( expected_compliance_map )
        expect( combined["SOLD_COURTESY_OF"]   ).to eq( expected_compliance_map )

        expect( combined["PLASTER_MLS_LOGO_IN_DETAILS"] ).to eq({
          "489" => "html for 489",
          "408" => "html for 408",
        })

        expect( combined["IDX_LOGO_IN_LISTINGS"] ).to eq({
          "489" => "idx 489",
          "408" => "idx 408",
        })

        expect( combined["SEARCH_STATUS_MAP"] ).to eq( combined_status_map )
        expect( combined["ALERT_STATUS_MAP"] ).to eq( combined_status_map )

        expect( combined ).to have_key("LM_AREA_MAPPER")
        expect( combined["LM_AREA_MAPPER"] ).to be nil
      end
    end
  end

end
