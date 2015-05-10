Chef.resource :tuxedo do
  property :version, String, identity: true
  property :patch, String
  property :ownername, String do
    default { 'tuxedo' }
  end
  property :groupname, String do
    default { 'tuxedo' }
  end
  property :password, String do
    default { 'luckluck' }
  end
  property :locale, String do
    default { 'en' }
  end
  property :tmp_dir, Path do
    default { '/tmp' }
  end
  property :home, Path do
    default { '/opt/oracle/Middleware/tuxedo-' + version }
  end
  property :cache_path, Path do
    default { ::File.join(Chef::Config[:file_cache_path], "tuxedo-#{version}") }
  end
  property :silent_path, Path do
    default { ::File.join(cache_path, silent_file) }
  end
  property :silent_file, Path do
    default { 'installer.properties' }
  end
  property :installer_url, String do
    default { node['common_artifact_repo'] + "/oracle/tuxedo/#{version}/#{installer_file}" }
  end
  property :installer_path, Path do
    default {  ::File.join(cache_path, installer_file) }
  end
  property :installer_file, Path do
    default { 'tuxedo12110_64_linux_5_x86.bin' }
  end
  property :patch_url, String do
    default { node['common_artifact_repo'] + "/oracle/tuxedo/#{version}/#{patch_file}" }
  end
  property :patch_file, String do
    default { "#{patch}.tar.Z" }
  end
  recipe do
    group groupname

    user ownername do
      group groupname
    end

    directory home do
      group groupname
      owner ownername
      recursive true
    end

    directory cache_path do
      group groupname
      owner ownername
      recursive true
    end

    template silent_path do
      group groupname
      owner ownername
      source silent_file + '.erb'
      cookbook 'tuxedo'
      variables(home: home, password: password, locale: locale)
    end

    remote_file installer_path do
      group groupname
      owner ownername
      source installer_url
    end

    execute "install tuxedo #{version}" do
      user ownername
      group groupname
      command "IATEMPDIR=#{tmp_dir} sh #{installer_path} -f #{silent_path}"
      not_if { ::File.exist? "#{home}/registry.xml" }
    end

    if patch
      ark patch do
        owner ownername
        group groupname
        url patch_url
        path home
        extension 'tar.gz'
        action :put
      end

      execute "apply tuxedo #{patch}" do
        cwd ::File.join(home, patch)
        user ownername
        group groupname
        command "printf '#{ownername}\n#{groupname}\n' | TUXDIR=#{home} ORACLE_HOME=#{home} sh install"
        not_if { ::File.exist?(::File.join(home, "uninstaller_#{patch}")) }
      end
    end
  end
end
