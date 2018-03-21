RSpec.describe TidyDesktop::Cleaner do
  EXAMPLE_FILES = [
    ['important_doc.docx', (DateTime.now - 2).to_time],
    ['not_so_important_image.png', (DateTime.now - 1).to_time],
    ['do_not_clean', (DateTime.now - 5).to_time]
  ].freeze
  before(:each) do
    @tmp_dir_source = Pathname.new(Dir.mktmpdir('tidy_desktop_rspec_'))
    EXAMPLE_FILES.each do |x|
      FileUtils.touch(@tmp_dir_source + (x[0]).to_s, mtime: x[1])
    end
    @tmp_dir_target = Pathname.new(Dir.mktmpdir('tidy_desktop_rspec_target'))
  end
  let(:cleaner) { TidyDesktop::Cleaner.new }
  let(:cleaner_ignore) { TidyDesktop::Cleaner.new(['do_not_clean']) }
  let(:target_directory) { Pathname.new(@tmp_dir_target.join(cleaner.daily_directory)) }

  after(:each) do
    # FileUtils.rm_rf @tmp_dir_source
    # FileUtils.rm_rf @tmp_dir_target
  end

  it 'initializes' do
    expect(cleaner).to_not be_nil
  end

  it 'initializes with params' do
    expect(cleaner).to_not be_nil
  end

  it 'has a today prefix' do
    expect(cleaner.daily_directory).to eq(DateTime.now.strftime('%d-%m-%Y'))
  end

  it 'cleans' do
    cleaner.clean!(@tmp_dir_source, @tmp_dir_target)
    EXAMPLE_FILES.each do |file|
      next if file[0] == 'do_not_clean'
      expect((target_directory + file[0]).exist?).to be true
    end
  end

  it 'cleans and ignores - file left' do
    cleaner_ignore.clean!(@tmp_dir_source, @tmp_dir_target)
    expect(Pathname.new(@tmp_dir_source + 'do_not_clean').exist?).to be true
  end

  it 'cleans and ignores today file ' do
    cleaner_ignore.clean!(@tmp_dir_source, @tmp_dir_target)
    expect(Pathname.new(@tmp_dir_source + 'do_not_clean').exist?).to be true
  end

  it 'cleans and ignores - file not copied' do
    cleaner_ignore.clean!(@tmp_dir_source, @tmp_dir_target)
    expect(Pathname.new(target_directory + 'do_not_clean').exist?).to be false
  end
end
