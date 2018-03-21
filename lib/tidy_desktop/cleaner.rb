module TidyDesktop
  # Moves files older then a day to specyfic location
  class Cleaner
    attr_reader :daily_directory
    def initialize(ignore = [])
      @daily_directory = Time.now.strftime('%d-%m-%Y')
      @ignore = ignore
    end

    def clean!(src, target)
      Pathname.glob("#{src.expand_path}/*") do |path|
        process_file_or_dir path, target
      end
    end

    private

    def process_file_or_dir(path, target)
      if today_file path
        puts "Cleaner: #{path} is today"
      elsif @ignore.include? path.basename.to_s
        puts "Cleaner: #{path} skipped"
      else
        puts "Cleaner: #{path} moved"
        move_file_or_dir path, target
      end
    end

    def move_file_or_dir(from, to)
      full_directory = to.join(@daily_directory)
      FileUtils.mkdir_p full_directory
      FileUtils.mv from, full_directory
    end

    def today_file(path)
      path.mtime.to_date == Time.now.to_date
    end
  end
end
