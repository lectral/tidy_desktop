RSpec.describe TidyDesktop::Configuration do
  before(:each) do
    @tmp_dir = Pathname.new(Dir.mktmpdir('td'))
    @temp_conf = @tmp_dir.join(".tidydesktop") 
  end
  

  let :configuration { TidyDesktop::Configuration.new(@temp_conf)} 

  after(:each) do
    FileUtils.rm_rf @tmp_dir
  end

  it 'initializes' do
    expect(configuration).to_not be_nil
  end

  it 'loads configuration from string' do
    configuration.load_from_string(SAMPLES.first[:file])
  end

  it 'creates default configuration' do
    @temp_dir = Dir.mktmpdir('td_')
    configuration.create_default(SAMPLES.first[:expected])
    expect(Pathname.new(@temp_conf).exist?).to be true
  end

  it 'creates sane configuration' do
    configuration.create_default(SAMPLES.first[:expected])
    content = YAML.load_file(@temp_conf)
    expect(content).to eq(SAMPLES.first[:expected])
  end

  it 'loads directory to cleanup' do
    SAMPLES.each do |sample|
      configuration.load_from_string(sample[:file])
      expect(configuration.directory).to eq(sample[:expected][:directory])
    end
  end

  it 'loads target directory' do
    SAMPLES.each do |sample|
      configuration.load_from_string(sample[:file])
      expect(configuration.target).to eq(sample[:expected][:target])
    end
  end

  it 'loads every time' do
    SAMPLES.each do |sample|
      configuration.load_from_string(sample[:file])
      expect(configuration.every).to eq(sample[:expected][:every])
    end
  end

  it 'loads ignore list' do
    SAMPLES.each do |sample|
      configuration.load_from_string(sample[:file])
      expect(configuration.ignore).to eq(sample[:expected][:ignore])
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
