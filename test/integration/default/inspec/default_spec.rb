describe user('tux') do
  it { should exist }
  it { should belong_to_group 'tux_grp' }
end

describe group('tux_grp') do
  it { should exist }
end

describe file('/opt/oracle/Middleware/tuxedo-12.1.1.0.0') do
  it { should be_a_directory }
  it { should be_owned_by 'tux' }
  it { should be_grouped_into 'tux_grp' }
end

describe file('/tmp/kitchen/cache/tuxedo-12.1.1.0.0/installer.properties') do
  it { should be_a_file }
  it { should be_owned_by 'tux' }
  it { should be_grouped_into 'tux_grp' }
  it { should contain 'INSTALLER_UI=silent' }
  it { should contain 'ORACLEHOME=/opt/oracle/Middleware/tuxedo-12.1.1.0.0' }
  it { should contain 'USER_INSTALL_DIR=/opt/oracle/Middleware/tuxedo-12.1.1.0.0' }
end

describe file('/tmp/kitchen/cache/tuxedo-12.1.1.0.0/tuxedo12110_64_linux_5_x86.bin') do
  it { should be_a_file }
  it { should be_owned_by 'tux' }
  it { should be_grouped_into 'tux_grp' }
end

describe file('/opt/oracle/Middleware/tuxedo-12.1.1.0.0/RP056/install') do
  it { should be_a_file }
  it { should be_owned_by 'tux' }
  it { should be_grouped_into 'tux_grp' }
end

describe file('/opt/oracle/Middleware/tuxedo-12.1.1.0.0/uninstaller_RP056') do
  it { should be_a_directory }
  it { should be_owned_by 'tux' }
  it { should be_grouped_into 'tux_grp' }
end
