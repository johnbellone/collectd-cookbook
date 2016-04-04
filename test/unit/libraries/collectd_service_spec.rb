require 'spec_helper'
require_relative '../../../libraries/collectd_service'

describe CollectdCookbook::Resource::CollectdService do
  step_into(:collectd_service)
  context 'with default node attributes' do
    recipe do
      collectd_service 'collectd'
    end

    it do expect(chef_run).to create_directory('/var/lib/collectd')
      .with(owner: 'collectd', group: 'collectd', mode: '0755')
    end
  end
end
