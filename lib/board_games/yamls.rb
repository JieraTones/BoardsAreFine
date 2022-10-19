module BoardGames

  module YAMLs
    extend self

    def combine_boards(board_ids:, boards_dir:, into_file:, board_ids_to_filenames: nil)
      if board_ids_to_filenames.nil?
        # search the slow way
        source_filenames = board_ids.flatten.collect { |board_id|
          find_original_board_yaml_file(directory: boards_dir, board_id: board_id)
        }
      else
        # use the cache, luke
        source_filenames = board_ids.flatten.collect { |board_id|
          board_ids_to_filenames[board_id]
        }
      end
      # p board_ids_to_filenames
      # p source_filenames

      yaml_strings = source_filenames.collect { |filename|
        full_path = File.join(boards_dir, filename)
        File.read(full_path)
      }
      output_path = File.join(boards_dir, into_file)
      combined_yaml = yaml_strings.collect(&:strip).join("\n")
      File.open( output_path, "w" ) do |f|
        f.write combined_yaml
      end
    end

    def scan_dir_for_board_yamls(path, progress_dots: false, max: nil)
      data = {}
      Dir.glob('*.yaml', base: path).each do |file_name|
        full_path = File.join(path, file_name)
        yaml_data = ::YAML.load_file(full_path)
        if yaml_data.keys.length == 1
          board_id = yaml_data.keys.first
          data[board_id] = file_name
        else
          # just move on to the next
        end

        if progress_dots
          print "." ; $stdout.flush
        end

        if max && data.length >= max
          break
        end
      end
      return data
    end

    def find_original_board_yaml_file(directory:, board_id:)
      Dir.glob('*.yaml', base: directory).detect { |candidate_file_name|
        full_path = File.join(directory, candidate_file_name)
        data = ::YAML.load_file(full_path)
        if data.keys.length == 1 && data.has_key?(board_id)
          candidate_file_name
        else
          nil
        end
      }
    end
  end

end
