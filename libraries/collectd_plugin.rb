#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CollectdCookbook
  module Resource
    # A `collectd_plugin` resource which manages the configuration of
    # a collectd plugin.
    # @action create
    # @action delete
    # @provides collectd_plugin
    # @since 2.0
    class CollectdPlugin < Chef::Resource
      include Poise(fused: true)
      provides(:collectd_plugin)

      # @!attribute plugin_name
      # @return [String]
      attribute(:plugin_name, kind_of: String, name_attribute: true)
      # @!attribute directory
      # @return [String]
      attribute(:directory, kind_of: String, default: '/etc/collectd.d')
      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')
      # @!attribute options
      # @return [Hash, Mash]
      attribute(:options, option_collector: true)

      # @return [String]
      def config_file
        ::File.join(directory, "#{plugin_name}.conf")
      end

      action(:create) do
        notifying_block do
          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end

          collectd_config new_resource.config_file do
            owner new_resource.user
            group new_resource.group
            configuration(
              'load_plugin' => new_resource.plugin_name,
              'plugin' => {
                'id' => new_resource.plugin_name
              }.merge(new_resource.options)
            )
          end
        end
      end

      action(:delete) do
        notifying_block do
          collectd_config new_resource.config_file do
            action :delete
          end
        end
      end
    end
  end
end
