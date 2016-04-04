#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'

module CollectdCookbook
  module Resource
    # A `collectd_service` resource for use with `poise_service`. This
    # resource manages the collectd service.
    # @action enable
    # @action disable
    # @action start
    # @action stop
    # @action restart
    # @provides collectd_service
    # @since 2.0
    class CollectdService < Chef::Resource
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin

      # @!attribute command
      # @return [String]
      attribute(:command, kind_of: String, default: lazy { default_command })
      # @!attribute program
      # @return [String]
      attribute(:program, kind_of: String, default: '/usr/sbin/collectd')
      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'collectd')
      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'collectd')
      # @!attribute directory
      # @return [String]
      attribute(:directory, kind_of: String, default: '/var/lib/collectd')
      # @!attribute config_file
      # @return [String]
      attribute(:config_file, kind_of: String, default: '/etc/collectd.conf')
      # @!attribute environment
      # @return [String]
      attribute(:environment, kind_of: Hash, default: { 'PATH' => '/usr/bin:/bin:/usr/sbin:/sbin' })

      # @return [String]
      def default_command
        "#{program} -C #{config_file} -f"
      end
    end
  end

  module Provider
    # A `collectd_service` provider for use with `poise_service`.
    # @action enable
    # @provides collectd_service
    # @since 2.0
    class CollectdService < Chef::Provider
      include Poise
      provides(:collectd_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do
          directory new_resource.directory do
            recursive true
            mode '0755'
            user new_resource.user
            group new_resource.group
          end
        end
        super
      end

      # Sets the tuning options for service management with
      # {PoiseService::ServiceMixin}.
      # @param [PoiseService::Service] service
      def service_options(service)
        service.command(new_resource.command)
        service.environment(new_resource.environment)
        service.directory(new_resource.directory)
        service.user(new_resource.user)
      end
    end
  end
end
