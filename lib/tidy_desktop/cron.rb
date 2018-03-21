module TidyDesktop
  # Adds daily tidy desktop job
  class Cron
    COMMAND = 'crontab'.freeze
    def initialize(command)
      @command = command
    end

    def output
      "@daily /bin/bash -c '#{@command}'\n"
    end

    def uninstall!
      crontab = current_crontab.delete_if { |a| a.include? @command.to_s }
      save_cron(crontab.join("\n"), 'r+')
    end

    def install!
      o = current_crontab.push(output)
      save_cron(o.join("\n"), 'r+')
    end

    def installed?
      `crontab -l`.include? @command
    end

    private

    def save_cron(content, mode)
      cmd = COMMAND + ' -'
      IO.popen(cmd, mode) do |cron|
        cron.write(content)
        cron.close_write
      end

      if $CHILD_STATUS.exitstatus.zero?
      else
        puts 'Error writing to crontab'
      end
    end

    def current_crontab
      `crontab -l`.lines
    end
  end
end
