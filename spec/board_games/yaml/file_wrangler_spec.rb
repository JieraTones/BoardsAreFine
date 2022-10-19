require "spec_helper"

RSpec.describe BoardGames::YAML::FileWrangler do
  let(:temp_dir) { PROJECT_ROOT.join("spec/temp") }
  before { FileUtils.rm_rf temp_dir }
  after  { FileUtils.rm_rf temp_dir }

  it "builds a Pathname from a :root and a :dirname" do
    wrangler = described_class.new(root: "/path/to", dirname: "dorian")
    expect( wrangler.working_dir ).to eq( Pathname.new("/path/to/dorian") )
  end

  specify "#working_dir is always downcased, even if :dirname has upper case letters" do
    wrangler = described_class.new(root: "/path/to", dirname: "HARPER")
    expect( wrangler.working_dir ).to eq( Pathname.new("/path/to/harper") )
  end

  describe "#prepare_filesystem" do
    it "creates the working dir" do
      wrangler = described_class.new(root: temp_dir, dirname: "foo")
      expect { wrangler.prepare_filesystem }.to \
        change { Dir.exist?(wrangler.working_dir) }.from( false ).to( true )
    end
  end

  describe "#create_file" do
    let(:wrangler) { described_class.new(root: temp_dir, dirname: "working") }
    let(:working)  { temp_dir.join("working") }

    it "creates a file in the working dir" do
      expected_filename = working.join("wibble.yaml")
      expect { wrangler.create_file(name: "wibble.yaml", data: "whatever") }.to \
        change { File.exist?(expected_filename) }.from( false ).to( true )
    end

    it "creates two files in the working dir" do
      wrangler.create_file(name: "wibble.yaml", data: "whatever")
      wrangler.create_file(name: "wobble.yaml", data: "revetahw")

      aggregate_failures do
        expect( File.exist?(working.join("wibble.yaml")) ).to be true
        expect( File.exist?(working.join("wobble.yaml")) ).to be true
      end
    end

    specify "when it creates a file, it also keeps a shadow copy" do
      shadow_filename = working.join(".shadow", "wibble.yaml")
      expect { wrangler.create_file(name: "wibble.yaml", data: "whatever") }.to \
        change { File.exist?(shadow_filename) }.from( false ).to( true )
    end
  end

  # It probably also needs to:
  # - maintain a cached/shadow copy of everything it writes (name: "shadow dir"?)
  # - fail gracefully, with an error message that doesn't make Greg DM me?
  #   - how might this thing break?
  # - clean up after itself
end
