require "spec_helper"

RSpec.describe BoardGames::Site do
  subject(:site) {
    described_class.new(
      identifier: "e03e3d1b-7d7d-4a1e-8c80-467dd4b37bf7", # totallynotrealgeeks.com
      settings: {
        "SITE_DOMAIN"      => "www.totallynotrealgeeks.com",
        "PROPERTY_DETAILS" => "not actually property details",
        "SEARCH_FIELDS"    => "not actually search fields",
        "SEARCH_FORMS"     => "not actually search forms",
      }
    )
  }

  let(:temp_dir) { PROJECT_ROOT.join("spec/temp") }

  # NOTE: this behavior will probably move somewhere else
  describe "#save_yamls_to" do
    before { FileUtils.rm_rf temp_dir }
    after  { FileUtils.rm_rf temp_dir }

    it "creates a property_details folder with a YAML file in it" do
      working_dir = temp_dir.join("property_details")
      creates_yaml_in_folder working_dir, \
        expected_contents: site.settings["PROPERTY_DETAILS"]
    end

    it "creates a search_fields folder with a YAML file in it" do
      working_dir = temp_dir.join("search_fields")
      creates_yaml_in_folder working_dir, \
        expected_contents: site.settings["SEARCH_FIELDS"]
    end

    it "creates a search_forms folder with a YAML file in it" do
      working_dir = temp_dir.join("search_forms")
      creates_yaml_in_folder working_dir, \
        expected_contents: site.settings["SEARCH_FORMS"]
    end

    def creates_yaml_in_folder(working_dir, expected_contents:)
      expect { site.save_yamls_to temp_dir }.to \
        change { working_dir.exist? }
        .from( false ).to( true )
      expect( working_dir.glob("*.yaml").length ).to eq( 1 )

      yaml = first_yaml_file_in( working_dir )
      expect( yaml ).to match( /.*?\.yaml/ )
      expect( yaml ).to_not match( /.*?\.yaml\.yaml/ )
      expect( File.read(yaml) ).to eq( expected_contents )
    end

    def first_yaml_file_in(working_dir)
      working_dir.glob("*.yaml").first.to_s
    end
  end

end
