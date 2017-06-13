name 'tuxedo'
maintainer 'University of Derby'
maintainer_email 'ai@derby.ac.uk'
license 'Apache-2.0'
description 'Installs & configures tuxedo'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
source_url        'https://github.com/universityofderby/tuxedo'
issues_url        'https://github.com/universityofderby/tuxedo/issues'
chef_version      '>= 12.5' if respond_to?(:chef_version)

depends 'ark'

%w( centos redhat scientific oracle amazon ).each do |os|
  supports os
end
