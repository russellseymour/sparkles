SfnRegistry.register(:compliance_versions, :provider => :azure) do
  [
    'azure_marketplace_5',
    'azure_marketplace_25',
    'azure_marketplace_50',
    'azure_marketplace_100',
    'azure_marketplace_150',
    'azure_marketplace_200',
    'azure_marketplace_250',
  ]
end

SfnRegistry.register(:compliance_default, :provider => :azure) do
  'azure_marketplace_5'
end
