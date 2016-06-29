SparkleFormation.dynamic(:publicip_address, :provider => :azure) do |name, opts = {}|

  if (opts.has_key?(:publicip) && opts[:publicip] == true)
    parameters do
      set!("#{name}_domain_name_label".to_sym) do
        type "string"
        default_value opts[:computername]
      end
    end

    variables do
      set!("#{name}_public_ip_address_name", "#{name}PublicIPAddress")
    end

    dynamic!(:network_public_ip_addresses, variables!("#{name}_public_ip_address_name").to_s, :resource_name_suffix => nil) do
      properties do
        set!('publicIPAllocationMethod', 'Dynamic')
        dns_settings.domain_name_label parameters!("#{name}_domain_name_label".to_sym)
      end
    end
  end
end
