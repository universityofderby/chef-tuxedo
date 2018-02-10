property :version, [String, Integer], name_property: true
property :patch, String
property :tux_user, String, default: 'tuxedo'
property :tux_group, String, default: 'tuxedo'
property :password, String, default: 'luckluck'
property :locale, String, default: 'en'
property :tmp_dir, String, default: '/tmp'
property :home, String, default: lazy { '/opt/oracle/Middleware/tuxedo-' + version }
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "tuxedo-#{version}") }
property :silent_path, String, default: lazy { ::File.join(cache_path, silent_file) }
property :silent_file, String, default: 'installer.properties'
property :artifact_repo, String, default: ''
property :installer_url, String, default: lazy { artifact_repo + "/oracle/tuxedo/#{version}/#{installer_file}" }
property :installer_path, String, default: lazy { ::File.join(cache_path, installer_file) }
property :installer_file, String, default: 'tuxedo12110_64_linux_5_x86.bin'
property :patch_url, String, default: lazy { artifact_repo + "/oracle/tuxedo/#{version}/#{patch_file}" }
property :patch_file, String, default: lazy {"#{patch}.tar.Z"}

provides :tuxedo

action :create do
  group tux_group

  user new_resource.tux_user do
    group new_resource.tux_group
  end

  directory new_resource.home do
    group new_resource.tux_group
    owner new_resource.tux_user
    recursive true
  end

  directory cache_path do
    group new_resource.tux_group
    tux_user new_resource.tux_user
    recursive true
  end

  template 'silent file' do
    path new_resource.silent_path
    group new_resource.tux_group
    owner new_resource.tux_user
    source silent_file + '.erb'
    cookbook 'tuxedo'
    variables(
              home: new_resource.home,
              password: new_resource.password,
              locale: new_resource.locale)
  end

  remote_file new_resource.installer_path do
    group new_resource.tux_group
    owner new_resource.tux_user
    source new_resource.installer_url
  end

  execute "install tuxedo #{version}" do
    user new_resource.tux_user
    group new_resource.tux_group
    command "IATEMPDIR=#{tmp_dir} sh #{new_resource.installer_path} -f #{new_resource.silent_path}"
    not_if { ::File.exist? "#{new_resource.home}/registry.xml" }
  end

  if patch
    ark patch do
      owner new_resource.tux_user
      group new_resource.tux_group
      url new_resource.patch_url
      path new_resource.home
      extension 'tar.gz'
      action :put
    end

    execute "apply tuxedo #{patch}" do
      cwd ::File.join(new_resource.home, patch)
      user new_resource.tux_user
      group new_resource.tux_group
      command "printf '#{new_resource.tux_user}\n#{new_resource.tux_group}\n' | TUXDIR=#{new_resource.home} ORACLE_HOME=#{new_resource.home} sh install"
      not_if { ::File.exist?(::File.join(new_resource.home, "uninstaller_#{patch}")) }
    end
  end
end
