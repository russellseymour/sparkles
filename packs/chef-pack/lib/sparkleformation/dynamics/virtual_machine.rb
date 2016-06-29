
SparkleFormation.dynamic(:virtual_machine, :provider => :azure) do |name, opts = {}|

  # Now create the machine
  dynamic!(:compute_virtual_machines, name) do
    depends_on! concat!('Microsoft.Storage/storageAccounts/', variables!(:storage_account_name))

    if opts[:plan]
      plan do
        name parameters!("#{name}_image_sku".to_sym)
        publisher opts[:publisher]
        product opts[:offer]
      end
    end

    properties do
      hardware_profile.vm_size parameters!("#{name}_vm_size".to_sym)
      os_profile do
        computer_name parameters!("#{name}_computer_name".to_sym)
        admin_username parameters!("#{name}_admin_username".to_sym)
        admin_password parameters!("#{name}_admin_password".to_sym)

        if opts[:customdata]
          custom_data opts[:customdata]
        end
      end
      storage_profile do
        image_reference do
          publisher opts[:publisher]
          offer opts[:offer]
          sku parameters!("#{name}_image_sku".to_sym)
          version "latest"
        end
        os_disk do
          name 'osdisk'
          vhd.uri concat!("https://", variables!(:storage_account_name), ".blob.core.windows.net/", parameters!(:storage_container_name), "/#{name}_osdisk.vhd")
          caching 'ReadWrite'
          create_option 'FromImage'
        end

        opts["#{name}".to_sym][:data_disks].each_with_index do |size, index|
          data_disks array!(
          -> {
             name "datadisk#{index + 1}"
             diskSizeGB size
             lun index
             vhd.uri concat!("https://", variables!(:storage_account_name), ".blob.core.windows.net/", parameters!(:storage_container_name), "/#{name}_datadisk_#{index + 1}.vhd")
             create_option "Empty"
           }
          )
        end

      end
      network_profile.network_interfaces array!(
        -> {
          id resource_id!("#{name}_network_interfaces".to_sym)
        }
      )
    end
  end

end
