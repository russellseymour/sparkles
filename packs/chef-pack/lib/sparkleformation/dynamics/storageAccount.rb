
SparkleFormation.dynamic(:storageAccount, :provider => :azure) do |vmname, opts = {}|

  parameters do

    set!("storage_container_name") do
      type "string"
      default_value opts.has_key?(:container_name) ? opts[:container_name] : "vhds"
    end

    set!("storage_account_type") do
      type "string"
      default_value "Standard_LRS"
    end

    # If a storage account name has been set then make sure it is a parameter with
    # a default value
    if (opts.has_key?(:storage) and
        opts[:storage].has_key?(:name) and
        !opts[:storage][:name].empty?)

        set!("storage_account_name") do
          type "string"
          default_value opts[:storage][:name]
        end
    end
  end

  # Set the variables that either relate to the parameter or generate a unique string
  variables do

    if (opts.has_key?(:storage) and
        opts[:storage].has_key?(:name) and
        !opts[:storage][:name].empty?)

        set!("storage_account_name") do
          value parameters!(:storage_account_name)
        end

      else

        set!("storage_account_name", unique_string!(subscription!.subscriptionId, resource_group!.id, parameters!("#{vmname}_computer_name".to_sym)))
    end

  end

  dynamic!(:storage_accounts, variables!(:storage_account_name).to_s, :resource_name_suffix => nil) do
    properties do
      account_type parameters!(:storage_account_type)
    end
  end

end
