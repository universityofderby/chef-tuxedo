# require 'spec_helper'
#
# describe 'role_blackboard::default' do
#  before(:each) do
#    stub_command('sudo -V').and_return('w00p')
#  end
#
#  let(:chef_run) do
#    runner = ChefSpec::Runner.new
#    runner.converge(described_recipe)
#  end
#
#  it 'creates Dan Webbs account' do
#    expect(chef_run).to create_user('782112')
#  end
#  it 'creates Richard Locks account' do
#    expect(chef_run).to create_user('782088')
#  end
#  it 'creates the Sandra Stevenson-Revills account' do
#    expect(chef_run).to create_user('sadm762')
#  end
# end
