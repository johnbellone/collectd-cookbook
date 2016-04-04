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
    # A resource for managing collectd plugins.
    # @action create
    # @action delete
    # @provides collectd_plugin_file
    # @since 2.0
    class CollectdPluginFile < Chef::Resource
      include Poise(fused: true)
      provides(:collectd_plugin_file)

      # @!attribute plugin_name
      # @return [String]
      attribute(:plugin_name, kind_of: String, name_attribute: true)
      # @!attribute plugin_instance_name
      # @return [String]
      attribute(:plugin_instance_name, kind_of: String)
      # @!attribute directory
      # @return [String]
      attribute(:directory, kind_of: String, default: '/etc/collectd.d')
      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')
      # @!attribute cookbook
      # @return [String]
      attribute(:cookbook, kind_of: String)
      # @!attribute source
      # @return [String]
      attribute(:source, kind_of: String)
      # @!attribute variables
      attribute(:variables, kind_of: Hash)

      # @return [String]
      def config_file
        ::File.join(directory, "#{plugin_name}_#{plugin_instance_name}.conf")
      end

      action(:create) do
        notifying_block do
          directory new_resource.directory do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end

          template new_resource.config_file do
            owner new_resource.user
            group new_resource.group
            cookbook new_resource.cookbook
            source new_resource.source
            variables new_resource.variables
          end
        end
      end

      action(:remove) do
        notifying_block do
          collectd_config new_resource.config_file do
            action :delete
          end
        end
      end
    end
  end
end
