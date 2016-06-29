
require "#{File.dirname(__FILE__)}/../../lib/defaults"

SparkleFormation.dynamic(:ubuntu, :provider => :azure) do |name, opts = {}|

  # Set the default option values
  opts[:os_type] = "linux"
  opts = Defaults.set(name, opts)

  # Set the virtual machine information
  opts[:publisher] = "Canonical"
  opts[:offer] = "UbuntuServer"

  # Set the parameters of the template
  parameters do
    set!("#{name}_image_sku".to_sym) do
      type "string"
      default_value registry!(:ubuntu_default)
      allowed_values registry!(:ubuntu_versions)
    end
  end

  dynamic!(:common, name, opts)


end
