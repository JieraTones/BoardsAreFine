module BoardGames
  module YAML

    class FileWrangler
      attr_reader :root, :dirname
      def initialize(root:, dirname:)
        @root, @dirname = root, dirname.downcase
      end

      def working_dir
        @_working_dir ||= Pathname.new(root).join(dirname)
      end

      def shadow_dir
        @_shadow_dir ||= working_dir.join(".shadow")
      end

      def prepare_filesystem
        FileUtils.mkdir_p working_dir
        FileUtils.mkdir_p shadow_dir
      end

      # TODO: probably need to normalize filenames / strip garbage
      def create_file(name:, data:)
        return if data.nil?
        write_data_to_filesystem data: data, filename: working_dir.join(name)
        write_data_to_filesystem data: data, filename: shadow_dir.join(name)
      rescue Errno::ENOENT
        prepare_filesystem
        retry # FIXME: might this recurse infinitely?
      end


      private

      def write_data_to_filesystem(filename:, data:)
        File.open(filename, "w") do |f|
          f << data
        end
      end
    end

  end
end
