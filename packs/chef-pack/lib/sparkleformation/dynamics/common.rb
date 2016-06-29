
SparkleFormation.dynamic(:common, :provider => :azure) do |name, opts = {}|

  parameters do
    set!("#{name}_vm_size".to_sym) do
      type "string"
      allowed_values registry!(:vmsize)
      default_value registry!(:vmsize_default, opts[:vmsize])
    end

    set!("#{name}_computer_name".to_sym) do
      type "string"
      default_value opts[:computername]
    end

    set!("#{name}_admin_username".to_sym) do
      type "string"
      default_value opts[:adminusername]
    end

    set!("#{name}_admin_password".to_sym) do
      type "securestring"
      default_value opts[:adminpassword]
    end
  end

  # Set a variable for the virtualNetwork and subnet references
  variables do

    set!(:virtual_network_name, opts[:network][:virtual][:name])
    set!(:subnet_name, opts[:network][:subnet][:name])
    set!("vnetID", resource_id!('Microsoft.Network/virtualNetworks', variables!("virtualNetworkName")))
    set!("subnetRef", concat!(variables!("vnetID"), '/subnets/', variables!("subnetName")))
  end

  dynamic!(:storageAccount, name, opts)

  # Only add in the virtual network if it is not specified as existing
  if !opts[:network][:virtual].has_key?(:exists) or (opts[:network][:virtual].has_key?(:exists) and !opts[:network][:virtual][:exists])
    dynamic!(:network_virtual_networks, variables!(:virtual_network_name).to_s, :resource_name_suffix => nil) do
      properties do
        address_space.address_prefixes opts[:network][:virtual][:prefixes]
        subnets array!(
          ->{
            name variables!(:subnet_name)
            properties.address_prefix opts[:network][:subnet][:prefixes]
          }
        )
      end
    end
  end

  dynamic!(:publicip_address, name, opts)

  dynamic!(:network_interfaces, name) do
    depends_on! concat!("Microsoft.Network/virtualNetworks", variables!(:virtual_network_name))
    properties.ip_configurations array!(
      ->{
        name 'ipconfig1'
        properties do
          set!('privateIPAllocationMethod', 'Dynamic')

          if (opts.has_key?(:publicip) && opts[:publicip] == true)
            set!('publicIPAddress').id resource_id!(variables!("#{name}_public_ip_address_name"))
          end

          subnet.id variables!("subnetRef")
        end
      }
    )
  end

  dynamic!(:virtual_machine, name, opts)

  dynamic!(:chef_extension, name, opts)
end
