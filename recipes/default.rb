#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
poise_service_user node['collectd']['service_user'] do
  group node['collectd']['service_group']
  not_if { node['collectd']['service_user'] == 'root' }
end

config = collectd_config node['collectd']['service_name'] do |r|
  owner node['collectd']['service_user']
  group node['collectd']['service_group']

  if node['collectd']['config']
    node['collectd']['config'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :restart, "collectd_service[#{name}]", :delayed
end

install = collectd_installation node['collectd']['service_name'] do |r|
  version node['collectd']['version']

  if node['collectd']['installation']
    node['collectd']['installation'].each_pair { |k, v| r.send(k, v) }
  end
  notifies :restart, "collectd_service[#{name}]", :delayed
end

collectd_service node['collectd']['service_name'] do |r|
  user node['collectd']['service_user']
  group node['collectd']['service_group']
  config_file config.path
  program install.collectd_program

  if node['collectd']['service']
    node['collectd']['service'].each_pair { |k, v| r.send(k, v) }
  end
end
