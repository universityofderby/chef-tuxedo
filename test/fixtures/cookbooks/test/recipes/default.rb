tuxedo '12.1.1.0.0' do
  patch 'RP056'
  tux_user 'tux'
  tux_group 'tux_grp'
  artifact_repo node['common_artifact_repo']
end
