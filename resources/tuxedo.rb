property :version, String, name_property: true
property :patch, String
property :owner, String, default: 'tuxedo'
property :group, String, default: 'tuxedo'
property :password, String, default: 'luckluck'
property :locale, String, default: 'en'
property :tmp_dir, String, default: '/tmp'
property :home, String, default: lazy { '/opt/oracle/Middleware/tuxedo-' + new_resource.version }
property :cache_path, String, default: lazy { ::File.join(Chef::Config[:file_cache_path], "tuxedo-#{version}") }
property :new_resource.silent_path, String, default: lazy { ::File.join(new_resource.cache_path, new_resource.silent_file) }
property :silent_file, String, default: 'installer.properties'
property :artifact_repo, String
property :installer_url, String, default: lazy { new_resource.artifact_repo + "/oracle/tuxedo/#{new_resource.version}/#{new_resource.installer_file}" }
property :installer_path, String, default: lazy { ::File.join(new_resource.cache_path, new_resource.installer_file) }
property :installer_file, String, default: 'tuxedo12110_64_linux_5_x86.bin'
property :patch_url, String, default: lazy { new_resource.artifact_repo + "/oracle/tuxedo/#{new_resource.version}/#{new_resource.patch_file}" }
property :patch_file, String, default: "#{new_resource.patch}.tar.Z"

action :create do
  group new_resource.group

  user new_resource.owner do
    group new_resource.group
  end

  directory new_resource.home do
    group new_resource.group
    owner new_resource.owner
    recursive true
  end

  directory cache_path do
    group new_resource.group
    owner new_resource.owner
    recursive true
  end

  template new_resource.silent_path do
    group new_resource.group
    owner new_resource.owner
    source silent_file + '.erb'
    cookbook 'tuxedo'
    variables(new_resource.home => new_resource.home,
              new_resource.password => new_resource.password,
              new_resource.locale => new_resource.locale)
  end

  remote_file new_resource.installer_path do
    group new_resource.group
    owner new_resource.owner
    source new_resource.installer_url
  end

  execute "install tuxedo #{version}" do
    user new_resource.owner
    group new_resource.group
    command "IATEMPDIR=#{tmp_dir} sh #{new_resource.installer_path} -f #{new_resource.silent_path}"
    not_if { ::File.exist? "#{new_resource.home}/registry.xml" }
  end

  if patch
    ark patch do
      owner new_resource.owner
      group new_resource.group
      url new_resource.patch_url
      path new_resource.home
      extension 'tar.gz'
      action :put
    end

    execute "apply tuxedo #{patch}" do
      cwd ::File.join(new_resource.home, patch)
      user new_resource.owner
      group new_resource.group
      command "printf '#{new_resource.owner}\n#{new_resource.group}\n' | TUXDIR=#{new_resource.home} ORACLE_new_resource.home=#{new_resource.home} sh install"
      not_if { ::File.exist?(::File.join(new_resource.home, "uninstaller_#{patch}")) }
    end
  end
end
