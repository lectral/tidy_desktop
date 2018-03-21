RSpec.describe TidyDesktop::Cron do
  let(:command) { 'tidy_desktop --run' }
  let(:cron) { TidyDesktop::Cron.new(command) }

  it 'initializes' do
    expect(cron).to_not be_nil
  end

  it 'creates cron output to run daily' do
    expect(cron.output.strip).to eq("@daily /bin/bash -c '#{command}'")
  end

  it 'saves in crontab' do
    cron.install!
    crontab = `crontab -l`
    expect(crontab).to include(command)
  end

  it 'uninstall from crontab' do
    cron.install! unless cron.installed?
    cron.uninstall!
    crontab = `crontab -l`
    expect(crontab).not_to include(command)
  end
end
