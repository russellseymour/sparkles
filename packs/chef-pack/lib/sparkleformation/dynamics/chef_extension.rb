SparkleFormation.dynamic(:chef_extension, :provider => :azure) do |name, opts = {}|

  # Add in the Chef Extension
  if (opts.has_key?(:chef))

    # Set a default for the key format
    if (opts[:key_format].nil?)
      opts[:key_format] = "base64encoded"
    end

    # based on the os_type set the type for the chefClient
    case opts[:os_type]
    when "windows"
      type = "ChefClient"
    else
      type = "LinuxChefClient"
    end

    # Set some values depending on whether they have been passed or not
    runlist = ""
    environment = "_default"

    if !opts[:chef][:runlist].nil?
      runlist = opts[:chef][:runlist]
    end
    if !opts[:chef][:environment].nil?
      environment = opts[:chef][:environment]
    end

    parameters do
      set!("chef_server_url") do
        type "string"
        default_value opts[:chef][:url]
      end

      set!("validation_client_name") do
        type "string"
        default_value opts[:chef][:validation_client_name]
      end

      set!("#{name}_runlist") do
        type "string"
        default_value runlist
      end

      set!("client_configuration") do
        type "string"
        default_value opts[:chef].has_key?(:clientrb) ? opts[:chef][:clientrb] : ""
      end

      set!("validation_key") do
        type "securestring"
        default_value opts[:chef].has_key?(:validation_key) ? opts[:chef][:validation_key] : ""
      end

      set!("#{name}_environment") do
        type "string"
        default_value environment
      end
    end

    dynamic!(:extensions, "#{name}ComputeVirtualMachines/chef") do
      type "Microsoft.Compute/virtualMachines/extensions"
      location "[resourceGroup().location]"
      depends_on!("#{name}_compute_virtual_machines".to_sym)
      properties do
        publisher "Chef.Bootstrap.WindowsAzure"
        type type
        typeHandlerVersion "1210.12"
        settings do
          camel_keys_set!(:auto_disable)
          validation_key_format opts[:key_format]
          bootstrap_options do
            chef_server_url parameters!("chef_server_url".to_sym)
            chef_node_name reference!("#{name}_network_public_ip_addresses".to_sym).dnsSettings.fqdn
            validation_client_name parameters!("validation_client_name".to_sym)
            environment parameters!("#{name}_environment".to_sym)
          end
          runlist parameters!("#{name}_runlist".to_sym)
          client_rb parameters!("client_configuration".to_sym)
          hints do
            cloud_platform "azure"
            public_fqdn reference!("#{name}_network_public_ip_addresses".to_sym).dnsSettings.fqdn
            vmname parameters!("#{name}_compute_virtual_machines".to_sym)
          end
        end
        protected_settings do
          camel_keys_set!(:auto_disable)
          validation_key parameters!("validation_key".to_sym)
        end
      end
    end
  end

end
