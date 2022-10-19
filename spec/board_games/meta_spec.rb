# frozen_string_literal: true

RSpec.describe "'vcr' gem configuration" do
  let(:conn) { Faraday.new("https://www.realgeeks.com") }

  def get_rg_root
    conn.get do |req|
      req.url '/'
    end
  end

  specify "trying to make an HTTP request using Faraday explodes" do
    expect { get_rg_root }.to \
      raise_error(VCR::Errors::UnhandledHTTPRequestError)
  end

  specify "RSpec has NOT been configured to use metadata in the usual way", :vcr do
    expect { get_rg_root }.to \
      raise_error(VCR::Errors::UnhandledHTTPRequestError)
  end

  describe "if you want to use VCR" do
    specify "you SHOULD use the helper" do
      with_vcr_cassette("rg.com root") do
        response = get_rg_root
        expect( response.status ).to eq( 200 )
      end
    end

    specify "but you COULD call it directly, if you HAD to" do
      VCR.use_cassette("rg.com root", record: :once) do
        response = get_rg_root
        expect( response.status ).to eq( 200 )
      end
    end
  end
end
