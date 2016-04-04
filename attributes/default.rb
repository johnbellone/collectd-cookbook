#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
default['collectd']['version'] = '5.4.0'

default['collectd']['service_name'] = 'collectd'
default['collectd']['service_user'] = 'collectd'
default['collectd']['service_group'] = 'collectd'

default['collectd']['config']['options']['plugin_dir'] = '/usr/lib/collectd'
default['collectd']['config']['options']['types_d_b'] = '/usr/share/collectd/types.db'
default['collectd']['config']['options']['interval'] = 10
default['collectd']['config']['options']['read_threads'] = 5
default['collectd']['config']['options']['write_threads'] = 5
default['collectd']['config']['options']['collect_internal_stats'] = true
