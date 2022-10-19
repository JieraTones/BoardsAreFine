def fixture_file_name(basename)
  "spec/fixtures/#{basename}"
end

def fixture_file_contents(basename)
  File.read(fixture_file_name(basename))
end

def default_vcr_record_mode
  # TODO: set this to :none on CI
end

def running_in_ci?
  false
end

def default_vcr_record_mode
  value_from_env = ENV["VCR_RECORD_MODE"].to_s.gsub(/\s+/, "").to_sym

  return :none if value_from_env.empty?
  return value_from_env if VCR::Cassette::VALID_RECORD_MODES.include?(value_from_env)

  raise "VCR_RECORD_MODE was set to #{value_from_env.inspect}, but the valid modes are #{VCR::Cassette::VALID_RECORD_MODES.inspect}"
end

def __get_vcr_debug_logger__
  VCR.configure do |vcr|
    return vcr.debug_logger
  end
end
def __set_vcr_debug_logger__(value)
  VCR.configure do |vcr|
    vcr.debug_logger = value
  end
end

def debug_vcr
  original_vcr_debug_logger = __get_vcr_debug_logger__
  __set_vcr_debug_logger__ $stdout

  line = "#" * 50
  puts "", line
  yield

ensure
  puts line, ""
  __set_vcr_debug_logger__ original_vcr_debug_logger
end


# NOTE: don't worry about calling this recursively
def with_vcr_cassette(name, opts = {})
  opts[:record] ||= default_vcr_record_mode
  VCR.use_cassette(name, **opts) do
    yield
  end

rescue ArgumentError => e
  if e.message =~ /cannot nest multiple cassettes with the same name/
    yield
  else
    raise
  end
end
