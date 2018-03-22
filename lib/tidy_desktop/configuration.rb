module TidyDesktop
  # Loads and saves user configuration
  class Configuration
    def initialize(path)
      @path = path
      @contents = ''
    end

    def load
      if(exist?)
        @contents = File.read(@path)
        parse
      end
    end

    def exist?
      @path.exist?
    end

    def load_from_string(string)
      @contents = string
      parse
    end

    def create_default(options)
      File.write(@path, options.to_yaml)
    end

    def loaded?
      !@contents.empty?
    end

    def directory
      Pathname.new(@configuration['directory'])
    end

    def target
      Pathname.new(@configuration['target'])
    end

    def method_missing(name, *args, &blk)
      if args.empty? && blk.nil? && @configuration.key?(name.to_s)
        @configuration[name.to_s]
      else
        super
      end
    end

    def respond_to_missing?
      super
    end

    private

    def parse
      @configuration = YAML.safe_load(@contents)
    end
  end
end
