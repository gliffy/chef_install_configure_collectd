#
# Cookbook Name:: chef_install_configure_collectd
# Recipe:: config_iostat
#
# Function:
# This recipe can configure the iostat plugin for collectd
#
# Copyright (c) 2016 SignalFx, Inc, All Rights Reserved.

require File.expand_path("../../libraries/helper.rb", __FILE__)

include_recipe 'chef_install_configure_collectd::default'
install_package_on_redhat 'epel-release'
package "sysstat"

directory node['iostat']['python_folder'] do
  action :create
  recursive true
end

template "#{node['iostat']['python_folder']}/collectd_iostat_python.py" do
  source 'collectd_iostat_python.py.erb'
  notifies :restart, 'service[collectd]'
end

template "#{node['collectd_managed_conf_folder']}/10-iostat.conf" do
  source '10-iostat.conf.erb'
  variables({
    :path => node['iostat']['path'],
    :verbose => node['iostat']['verbose'],
    :python_folder => node['iostat']['python_folder'],
    :include => node['iostat']['include']
  })
  notifies :restart, 'service[collectd]'
end

start_collectd
