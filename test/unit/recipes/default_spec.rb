require 'spec_helper'

describe 'collectd::default' do
  cached(:chef_run) { ChefSpec::SoloRunner.converge('collectd::default') }
  it { expect(chef_run).to create_poise_service_user('collectd').with(group: 'collectd') }
  it do expect(chef_run).to create_collectd_config('collectd')
    .with(owner: 'collectd')
    .with(group: 'collectd')
  end
  it { expect(chef_run).to create_collectd_installation('5.5.0') }
  it do expect(chef_run).to enable_collectd_service('collectd')
    .with(user: 'collectd')
    .with(group: 'collectd')
  end
end
