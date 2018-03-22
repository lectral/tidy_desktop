module TidyDesktop
  # Handles the command line arguments of this app
  class CommandLine
    def initialize

    end

    def parse
      OptionParser.new do |opt|
        opt.banner = 'Please run --install or --uninstall to install script '\
          'crontab'
        opt.on('-i', '--install', 'Install TidyDesktop in crontab') do
          @on_install.call 
        end
        opt.on('-u', '--uninstall', 'Uninstall TidyDesktop from crontab') do
          @on_uninstall.call
        end
        opt.on('-u', '--run', 'Run cleaner') { |_o| @on_run.call }
      end.parse!

    end

    def on_install(&block)
      @on_install = block
    end

    def on_uninstall(&block)
      @on_uninstall = block
    end

    def on_run(&block)
      @on_run = block
    end


  end
end
