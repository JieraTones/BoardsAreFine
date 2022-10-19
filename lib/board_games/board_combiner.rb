require_relative "board_combiner/field"

module BoardGames

  class BoardCombiner
    SETTINGS_LISTS = {
      "COURTESY_OF_PLACEMENT" => [
        "above price",
        "above widgets",
        "below slideshow photo",
        "bottom of page",
      ],
      "COURTESY_OF_PLACEMENT_IN_MAPSEARCH_RESULTS" => [
        "top",
        "bottom",
      ],
      "COURTESY_OF_PLACEMENT_IN_RESULTS" => [
        "top",
        "bottom",
      ],
      "DISCLAIMER_PLACEMENT" => [
        "above widgets",
        "bottom of page",
      ],
      "MAP_SEARCH_DISCLAIMER_POSITION" => [
        "at bottom",
        "in results list",
      ],
      "PHOTOS_ON_SOLDS" => [
        "no photos",
        "first photo only",
        "all photos",
      ],
      "RESIZE_THUMBNAILS_TO_FIT" => [
        "width",
        "height",
        "trim to fit",
      ],
    }



    FIELDS = [] # this will be populated shortly...
    def self.field(constructor, name, *args)
      field = Field.send(constructor, name, *args)
      FIELDS << field
    end

    field :list,               "RG_BOARDS"
    field :boolean_true,       "ENABLE_CRAIGSLIST_TOOL"
    field :boolean_true,       "GALLERY_BUTTONS_ON_SLIDESHOW_PHOTOS"
    field :boolean_true,       "RG_ENABLE_VIRTUAL_TOUR"
    field :boolean_true,       "RG_SHOW_PRICE_CHANGES"
    field :boolean_true,       "SHOW_COMPANY_STAMP"
    field :boolean_true,       "SHOW_LIST_PRICE_ON_SOLDS"
    field :boolean_false,      "COURTESY_OF_SHOWN_IN_GALLERY"
    field :boolean_false,      "ENABLE_HSTS_HEADER"
    field :boolean_false,      "ENABLE_X_FRAME_OPTIONS"
    field :boolean_false,      "MEGA_DISCLAIMER"
    field :boolean_false,      "REG_MARK_ON_MLS"
    field :boolean_false,      "REG_MARK_ON_REALTOR"
    field :boolean_false,      "RG_ENABLE_RENTALS"
    field :boolean_false,      "RG_HIDE_CONTACT_BUTTON_ON_PROPERTY_DETAILS_PAGE"
    field :boolean_false,      "RG_HIDE_REMARKS_ON_LIST_VIEW"
    field :boolean_false,      "SHOW_LIVING_AREA_SOURCE"
    field :boolean_false,      "SPAM_LOGO_ON_MAP_SEARCH"
    field :boolean_false,      "VALUATION_CANADA_LABELS"
    field :strict_setting,     "COURTESY_OF_PLACEMENT"
    field :strict_setting,     "COURTESY_OF_PLACEMENT_IN_MAPSEARCH_RESULTS"
    field :strict_setting,     "COURTESY_OF_PLACEMENT_IN_RESULTS"
    field :strict_setting,     "DISCLAIMER_PLACEMENT"
    field :strict_setting,     "MAP_SEARCH_DISCLAIMER_POSITION"
    field :strict_setting,     "PHOTOS_ON_SOLDS"
    field :strict_setting,     "RESIZE_THUMBNAILS_TO_FIT"
    field :hash,               "COURTESY_OF"
    field :hash,               "DISCLAIMER_DETAIL"
    field :hash,               "DISCLAIMER_RESULTS"
    field :hash,               "IDX_LOGO_IN_LISTINGS"
    field :hash,               "PLASTER_MLS_LOGO_IN_DETAILS"
    field :hash,               "SOLD_COURTESY_OF"
    field :text,               "DISCLAIMER_FOOTER"
    field :lowest_number_wins, "RG_LIMIT_RESULT_COUNT"
    field :lowest_number_wins, "SOLD_WITHIN_MAX"
    field :status_map,         "ALERT_STATUS_MAP"
    field :status_map,         "SEARCH_STATUS_MAP"

    field :hardcode, "LIMIT_SEARCH_CRITERIA",           {}
    field :hardcode, "LM_AREA_ATTRS",                   "region, community, county, city, subdivision, neighborhood"
    field :hardcode, "LM_AREA_MAPPER",                  nil
    field :hardcode, "PROPERTY_CACHE_TIME",             5
    field :hardcode, "PROP_LISTINGS_FULL_DETAILS",      "beds,baths,br,mls,square_footage,status"
    field :hardcode, "PROP_LISTINGS_MAPSEARCH_DETAILS", "beds,baths,square_footage,status"
    field :hardcode, "PROP_LISTINGS_QUICK_DETAILS",     "beds,baths,mls,building_name,listing_office"
    field :hardcode, "RG2_SEARCH_FIELDS",               "combo_default_dont_edit.yaml"
    field :hardcode, "RG2_SEARCH_FORMS",                "combo_default_dont_edit.yaml"
    field :hardcode, "PROP_FIELDS_YML",                 "default.yaml"
    field :hardcode, "RG_PROPERTY_UNIQUE_ID",           "mls_number"

    def self.field_names
      FIELDS.map(&:name).sort
    end



    attr_reader :boards, :return_json
    def initialize(*boards, return_json: false)
      @boards      = boards.flatten
      @return_json = return_json
    end


    def call
      FIELDS.each do |field|
        field.populate(self)
      end

      if return_json
        return JSON.pretty_generate( combined )
      else
        return combined
      end
    end

    def populate(field_name, strategy: nil, kwargs: nil)
      values = boards.map { |board| board[field_name] }.compact
      combined_values = CombineValues.send(strategy, values, **kwargs)
      combined[field_name] = combined_values
      nil
    rescue StandardError => e
      puts "\n"
      puts "Hey, you have a problem in field #{field_name}"
      puts "\n"
      raise e
    end

    private

    def combined
      @_combined ||= {}
    end
  end

end
