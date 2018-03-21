module TidyDesktop
  class App
    CONFIGURATION_FILE_PATH = Pathname.new(%(#{ENV['HOME']}/.tidydesktop))
    def initialize; end

    def run
      OptionParser.new do |opt|
        opt.banner = 'Please run --install or --uninstall to install script in crontab'
        opt.on('-i', '--install', 'Install TidyDesktop in crontab') do |_o|
          install
        end
        opt.on('-u', '--uninstall', 'Uninstall TidyDesktop from crontab') do |_o|
          uninstall
        end
        opt.on('-u', '--run', 'Run cleaner') { |_o| clean }
      end.parse!
    end

    private

    def clean
      @configuration = Configuration.new
      if CONFIGURATION_FILE_PATH.exist?
        @configuration.load_from_file(CONFIGURATION_FILE_PATH)
        cleaner = Cleaner.new(@configuration.ignore)
        cleaner.clean!(@configuration.directory, @configuration.target)
      else
        puts "Please create configuration file first (#{CONFIGURATION_FILE_PATH})"
      end
    end

    def install_to_crontab; end

    def install
      @configuration = Configuration.new
      if CONFIGURATION_FILE_PATH.exist?
        install_crontab
      else
        create_configuration
      end
    end

    def install_crontab
      @configuration.load_from_file(CONFIGURATION_FILE_PATH)
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
      @configuration.create_default(options, CONFIGURATION_FILE_PATH.expand_path)
      puts 'Please review configuration and run tidy_desktop --install again
            when you are ready'
    end

    def uninstall
      crontab = Cron.new('tidy_desktop --run')
      crontab.uninstall!
    end
  end
end
