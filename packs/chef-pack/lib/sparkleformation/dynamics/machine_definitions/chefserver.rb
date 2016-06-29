
require "#{File.dirname(__FILE__)}/../../lib/defaults"

SparkleFormation.dynamic(:chefserver, :provider => :azure) do |name, opts = {}|

  # Set the default option values
  opts = Defaults.set(name, opts)

  # Set the virtual machine information
  opts[:publisher] = "chef-software"
  opts[:offer] = "chef-server"
  opts[:vmsize] = "Standard_A1"

  # Set the parameters of the template
  parameters do
    set!("#{name}_image_sku".to_sym) do
      type "string"
      default_value registry!(:chefserver_default)
      allowed_values registry!(:chefserver_versions)
    end
  end

  # Add in the Cloud Init configuration file headers
  variables do
    set!(:cloud_head, "#cloud_config\nmanage_etc_hosts: true\n\npackage_update: true\npackage_upgrade: false\n")
  end

  # Set some customdata in the opts so that the chef server is configured
  opts[:customdata] = base64!(concat!(variables!(:cloud_head), 'fqdn:', reference!(variables!("#{name}_public_ip_address_name".to_sym)).dnsSettings.fqdn, "\n"))

  # ensure that the plan information is set so that the AMP image can be used
  opts[:plan] = true

  dynamic!(:common, name, opts)


end
