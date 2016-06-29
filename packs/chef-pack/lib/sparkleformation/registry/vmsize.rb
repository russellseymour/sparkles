SfnRegistry.register(:vmsize, :provider => :azure) do
  [
    'Standard_A1',
    'Standard_A2',
    'Standard_A3',
    'Standard_D1',
    'Standard_D2',
    'Standard_D3'
  ]
end

SfnRegistry.register(:vmsize_default, :provider => :azure) do |size = 'Standard_D1'|
  size
end
