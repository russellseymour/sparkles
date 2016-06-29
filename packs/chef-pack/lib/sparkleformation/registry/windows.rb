SfnRegistry.register(:windows_versions, :provider => :azure) do
  [
    '2008-R2-SP1',
    '2012-Datacenter',
    '2012-R2-Datacenter',
    '2016-Nano-Server-Technical-Preview',
    '2016-Technical-Preview-with-Containers',
    'Windows-Server-Technical-Preview'
  ]
end

SfnRegistry.register(:windows_default, :provider => :azure) do
  '2012-R2-Datacenter'
end
