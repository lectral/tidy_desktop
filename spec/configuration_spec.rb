RSpec.describe TidyDesktop::Configuration do
  before(:each) do
    @configuration = TidyDesktop::Configuration.new
    @tmp_dir = Dir.mktmpdir('td')
  end

  after(:each) do
    FileUtils.rm_rf @tmp_dir
  end

  it 'initializes' do
    expect(@configuration).to_not be_nil
  end

  it 'loads configuration from string' do
    @configuration.load_from_string(SAMPLES.first[:file])
  end

  it 'creates default configuration' do
    @temp_dir = Dir.mktmpdir('td_')
    temp_conf = @tmp_dir + '/' + '.tidydesktop'
    @configuration.create_default(SAMPLES.first[:expected], temp_conf)

    expect(Pathname.new(temp_conf).exist?).to be true
  end

  it 'creates sane configuration' do
    temp_conf = @tmp_dir + '/' + '.tidydesktop'
    @configuration.create_default(SAMPLES.first[:expected], temp_conf)
    content = YAML.load_file(temp_conf)
    expect(content).to eq(SAMPLES.first[:expected])
  end

  it 'loads directory to cleanup' do
    SAMPLES.each do |sample|
      @configuration.load_from_string(sample[:file])
      expect(@configuration.directory).to eq(sample[:expected][:directory])
    end
  end

  it 'loads target directory' do
    SAMPLES.each do |sample|
      @configuration.load_from_string(sample[:file])
      expect(@configuration.target).to eq(sample[:expected][:target])
    end
  end

  it 'loads every time' do
    SAMPLES.each do |sample|
      @configuration.load_from_string(sample[:file])
      expect(@configuration.every).to eq(sample[:expected][:every])
    end
  end

  it 'loads ignore list' do
    SAMPLES.each do |sample|
      @configuration.load_from_string(sample[:file])
      expect(@configuration.ignore).to eq(sample[:expected][:ignore])
    end
  end

  SAMPLES = [
    {
      file: %(---
        directory: ~/Desktop
        target: ~/daily
        every: 1h
        ignore:
          - do_not_clean.txt
      ),
      expected: {
        directory: Pathname.new('~/Desktop'),
        target: Pathname.new('~/daily'),
        every: '1h',
        ignore: ['do_not_clean.txt']
      }
    }
  ].freeze
end
