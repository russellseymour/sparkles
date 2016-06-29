SfnRegistry.register(:chefserver_versions, :provider => :azure) do
  [
    'chefbyol',
    'azure_marketplace_25',
    'azure_marketplace_50',
    'azure_marketplace_100',
    'azure_marketplace_150',
    'azure_marketplace_200',
    'azure_marketplace_250',
  ]
end

SfnRegistry.register(:chefserver_default, :provider => :azure) do
  'chefbyol'
end
