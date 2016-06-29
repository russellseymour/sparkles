
module Defaults

  def Defaults.set(name, opts)

    # Based on the options that have been passed in determine the
    #  - computername
    #  - adminusername
    #  - adminpassword
    !opts.has_key?(:computername) ? opts[:computername] = "%s-01" % [name] : false
    !opts.has_key?(:adminusername) ? opts[:adminusername] = "azure" : false
    !opts.has_key?(:adminpassword) ? opts[:adminpassword] = "Passw0rd!" : false
    !opts.has_key?(:datadisksize) ? opts[:datadisksize] = 100 : false
    !opts.has_key?(:vmsize) ? opts[:vmsize] = "Standard_D1" : false

    # Set some network defaults if they have not been set
    !opts.has_key?(:network) ? opts[:network] = {} : false

    !opts[:network].has_key?(:virtual) ? opts[:network][:virtual] = {} : false
    !opts[:network].has_key?(:subnet) ? opts[:network][:subnet] = {} : false

    !opts[:network][:virtual].has_key?(:name) ? opts[:network][:virtual][:name] = "virtualNetwork" : false
    !opts[:network][:subnet].has_key?(:name) ? opts[:network][:subnet][:name] = "subnet" : false

    !opts[:network][:virtual].has_key?(:prefixes) ? opts[:network][:virtual][:prefixes] = ['10.0.0.0/24'] : false
    !opts[:network][:subnet].has_key?(:prefixes) ? opts[:network][:subnet][:prefixes] = ['10.0.0.0/25'] : false

    # Ensure that the opts hash has a key with the name of the machine
    if (!opts.has_key?("#{name}".to_sym))
      opts["#{name}".to_sym] = {}
    end

    # If no data disks have been set add one now
    if (!opts["#{name}".to_sym].has_key?(:data_disks))
      opts["#{name}".to_sym][:data_disks] = [opts[:datadisksize]]
    end

    return opts
  end
end
