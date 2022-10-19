# frozen_string_literal: true


require "board_games"

require "vcr"

require "awesome_print"
require "table_print"
require "pry"

require_relative "support/helpers"

require "pathname"
PROJECT_ROOT = Pathname.new(File.dirname(__FILE__)).join("..").expand_path


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Always clear the global that Sam has a tendency to set
  config.after(:each) do
    $debug = false
  end
end



VCR.configure do |vcr|
  vcr.cassette_library_dir = "spec/vcr/cassettes"
  vcr.hook_into :faraday

  # NOTE: Because I have a tendency to rename specs (like, a LOT),
  # VCR's default RSpec integration is not helpful.
  # It's simpler (for me) to just call `VCR.use_cassette` directly.
  # -SLG
  #
  # vcr.configure_rspec_metadata!

  # By default, DO NOT record new interactions.
  # Between this and the lack of `configure_rspec_metadata!`,
  # it should be VERY obvious where VCR is used.  (And, I hope, rare.)
  vcr.default_cassette_options = {
    record: :none,
  }

end


