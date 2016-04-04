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
    # A `collectd_installation` resource which manages the collectd
    # installation.
    # @action create
    # @action remove
    # @provides collectd_installation
    # @since 3.0
    class CollectdInstallation < Chef::Resource
      include Poise(inversion: true)
      provides(:collectd_installation)
      actions(:create, :remove)
      default_action(:create)

      # @!attribute version
      # The version of collectd to install.
      # @return [String]
      attribute(:version, kind_of: String, name_attribute: true)

      def collectd_program
        @program ||= provider_for_action(:collectd_program).collectd_program
      end
    end
  end
end
