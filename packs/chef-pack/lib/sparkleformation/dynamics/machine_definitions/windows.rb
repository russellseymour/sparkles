
require "#{File.dirname(__FILE__)}/../../lib/defaults"

SparkleFormation.dynamic(:windows, :provider => :azure) do |name, opts = {}|

  # Set the default option values
  opts[:os_type] = "windows"
  opts = Defaults.set(name, opts)

  # Set the virtual machine information
  opts[:publisher] = "MicrosoftWindowsServer"
  opts[:offer] = "WindowsServer"

  # Set the parameters of the template
  parameters do
    set!("#{name}_image_sku".to_sym) do
      type "string"
      default_value registry!(:windows_default)
      allowed_values registry!(:windows_versions)
    end
  end

  dynamic!(:common, name, opts)

end
