SfnRegistry.register(:ubuntu_versions, :provider => :azure) do
  [
    '12.04.5-LTS',
    '12.10',
    '14.04.4-LTS',
    '14.10',
    '15.04',
    '15.10',
    '16.04.0-LTS'
  ]
end

SfnRegistry.register(:ubuntu_default, :provider => :azure) do
  '16.04.0-LTS'
end
