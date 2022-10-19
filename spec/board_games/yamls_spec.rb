# frozen_string_literal: true

RSpec.describe BoardGames::YAMLs do
  subject { described_class }

  let(:board1) { fixture_file_contents("board-1.yaml") }
  let(:board2) { fixture_file_contents("board-2.yaml") }
  let(:board3) { fixture_file_contents("board-3.yaml") }

  describe ".find_original_board_yaml_file" do
    it "finds the first YAML file in a given directory that contains ONLY the given board ID" do
      filename = subject.find_original_board_yaml_file(
        directory: "spec/fixtures",
        board_id:  1,
      )
      expect( filename ).to eq( "board-1.yaml" )
    end

    # it "might need to find more than one file"
    # it "probably doesn't need to know about trestle (which has two IDs: 405, 1405)"
  end

  specify "scan_dir_for_board_yamls returns a Hash of board IDs to filenames that contain ONLY that board" do
    data = subject.scan_dir_for_board_yamls( "spec/fixtures" )
    expect( data ).to eq(
      {
        1 => "board-1.yaml",
        2 => "board-2.yaml",
        3 => "board-3.yaml",
        # BUT not "board-1-and-2.yaml" because it's a combo
      }
    )
  end


  describe ".combine_boards" do
    let(:target_filename) { "frankenboard.yaml" }
    let(:temp_path) { "spec/tmp" }

    before do
      FileUtils.rm_rf(temp_path)
      FileUtils.mkdir_p(temp_path)
      yaml_files = Dir.glob("spec/fixtures/*.yaml")
      FileUtils.cp yaml_files, temp_path
    end

    after do
      FileUtils.rm_rf(temp_path)
    end

    it "takes two board IDs and a filename, finds the board YAMLs, combines them, and writes to the file" do
      output_filename = File.join(temp_path, "frankenboard.yaml")
      expect {
        subject.combine_boards(
          board_ids:  [ 1, 2 ],
          boards_dir: temp_path,
          into_file:  "frankenboard.yaml"
        )
      }.to change { File.exist?( output_filename ) }
        .from( false ).to( true )
      actual_contents = File.read(output_filename)
      expected_contents = fixture_file_contents("board-1-and-2.yaml").strip
      expect( actual_contents ).to eq( expected_contents )
    end
  end

end
