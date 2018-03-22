module TidyDesktop
  # Glues everything together and handles command line interface
  class App
    CONFIGURATION_FILE_PATH = Pathname.new(%(#{ENV['HOME']}/.tidydesktop))
    def initialize; end

    def run
      command_line = CommandLine.new
      command_line.on_install { install }
      command_line.on_uninstall { uninstall }
      command_line.on_run { clean }
      command_line.parse
    end

    private

    def clean
      @configuration = Configuration.new(expanded_configuration_file_path)
      if @configuration.exist?
        @configuration.load
        cleaner = Cleaner.new(@configuration.ignore)
        cleaner.clean!(@configuration.directory, @configuration.target)
      else
        puts 'Please create configuration file first '\
          "(#{CONFIGURATION_FILE_PATH})"
      end
    end

    def install_to_crontab; end

    def install
      @configuration = Configuration.new(expanded_configuration_file_path)
      if CONFIGURATION_FILE_PATH.exist?
        install_crontab
      else
        create_configuration
      end
    end


    def install_crontab
      @configuration.load(CONFIGURATION_FILE_PATH)
      crontab = Cron.new('tidy_desktop --run')
      crontab.install!
      puts 'Crontab installed.'
    end

    def create_configuration
      puts "Creating default configuration in #{CONFIGURATION_FILE_PATH}"
      options = {
        'directory' => '~/Desktop',
        'target' => '~/daily',
        'every' => '1h',
        'ignore' => []
      }
      @configuration.create_default(options)
      puts 'Please review configuration and run tidy_desktop --install again'\
            'when you are ready'
    end

    def expanded_configuration_file_path
      CONFIGURATION_FILE_PATH.expand_path
    end

    def uninstall
      crontab = Cron.new('tidy_desktop --run')
      crontab.uninstall!
    end
  end
end
