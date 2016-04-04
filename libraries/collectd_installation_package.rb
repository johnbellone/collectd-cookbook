#
# Cookbook: collectd
# License: Apache 2.0
#
# Copyright 2010, Atari, Inc.
# Copyright 2015-2016, Bloomberg Finance L.P.
#
require 'poise'

module CollectdCookbook
  module Provider
    # A `collectd_installation` provider which installs collectd from
    # a package source.
    # @action create
    # @action remove
    # @provides collectd_installation
    # @example
    #   collectd_installation '5.5.0'
    # @since 3.0
    class CollectdInstallationPackage < Chef::Provider
      include Poise(inversion: :collectd_installation)
      provides(:package)
      inversion_attribute('collectd')

      # @api private
      def self.provides_auto?(_node, _resource)
        true
      end

      # Set the default inversion options.
      # @return [Hash]
      # @api private
      def self.default_inversion_options(node, resource)
        super.merge(
          package_name: 'collectd'
        )
      end

      def action_create
        notifying_block do
          if options[:package_source]
            f = remote_file options[:package_name] do
              path ::File.join(Chef::Config[:file_cache_path], ::File.basename(url))
              source options[:package_source] % {version: options[:version]}
              checksum options[:package_checksum] if options[:package_checksum]
              notifies :upgrade, "package[#{name}]", :immediately
            end

            package options[:package_name] do
              action :nothing
              provider Chef::Provider::Package::Solaris if platform?('solaris2')
              provider Chef::Provider::Package::Dpkg if platform?('ubuntu')
              version options[:version]
              source f.path
            end
          else
            _n = options[:package_name]
            package _n do
              version "#{new_resource.version}*"
            end
          end
        end
      end

      def action_remove
        notifying_block do
          package options[:package_name] do
            version options[:version]
            action :remove
          end
        end
      end

      def collectd_program
        options.fetch(:program, '/usr/sbin/collectd')
      end
    end
  end
end
