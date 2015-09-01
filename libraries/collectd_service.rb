#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module CollectdCookbook
  module Resource
    # A resource for managing the collectd monitoring daemon.
    # @since 2.0.0
    class CollectdService < Chef::Resource
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin

      # @!attribute user
      # User to run the collectd daemon as. Defaults to 'collectd.'
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')

      # @!attribute group
      # Group to run the collectd daemon as. Defaults to 'collectd.'
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')

      # @!attribute directory
      # The working directory for the service. Defaults to the data
      # directory '/var/lib/collectd'.
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/lib/collectd')

      # @!attribute configuration_directory
      # Name of directory where additional configurations reside. Defaults to
      # '/etc/collectd.d'.
      # @return [String]
      attribute(:config_directory, kind_of: String, default: '/etc/collectd.d')

      # @!attribute config_filename
      # The configuration file for the daemon service. Defaults to
      # '/etc/collectd.conf'.
      # @return [String]
      attribute(:config_filename, kind_of: String, default: '/etc/collectd.conf')

      # @!attribute configuration
      # Set of key-value options to write to {#config_filename}.
      # @see {https://collectd.org/documentation/manpages/collectd.conf.5.shtml#global_options}
      # @return [Hash, Mash]
      attribute(:configuration, option_collector: true)

      # @!attribute package_name
      # @return [String]
      attribute(:package_name, kind_of: String, default: 'collectd')

      # @!attribute package_version
      # @return [String]
      attribute(:package_version, kind_of: String)
    end
  end

  module Provider
    # A provider for managing collectd daemon as a service.
    # @since 2.0.0
    class CollectdService < Chef::Provider
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin
      include CollectdCookbook::Helpers

      def action_enable
        notifying_block do
          package new_resource.package_name do
            version new_resource.package_version if new_resource.package_version
            action :upgrade
          end

          directory [new_resource.config_directory, new_resource.directory] do
            recursive true
            owner new_resource.user
            group new_resource.group
            mode '0755'
          end

          directives = [
            '# This file is autogenerated by Chef.',
            '# Do not edit; All changes will be overwritten!',
            build_configuration(new_resource.configuration.merge(
              'base_dir' => new_resource.directory,
              'hostname' => node['hostname']
            )),
            %(Include "#{new_resource.config_directory}"\n)
          ]

          file new_resource.config_filename do
            content directives.flatten.join("\n")
            mode '0644'
          end
        end
        super
      end

      def action_disable
        notifying_block do
          file new_resource.config_filename do
            action :delete
          end
        end
        super
      end

      # Sets the tuning options for service management with {PoiseService::ServiceMixin}.
      # @param [PoiseService::Service] service
      def service_options(service)
        service.command("/usr/sbin/collectd -C #{new_resource.config_filename} -f")
        service.restart_on_update(true)
      end
    end
  end
end
