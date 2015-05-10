# Tuxedo Cookbook

## Scope
This cookbook installs Oracle Tuxedo also known as Oracle Fusion Middleware
Application Server.
Oracle Java is also installed as a required dependency.
It does not install or manage any services.

## Requirements
* Chef 12 or higher
* Network accessible artifact repository

## Platform
* Centos 6
* Red Hat Enterprise 6

## Usage

### Resources
```
tuxedo '12.1.1.0.0' do
  version '12.1.1.0.0'
  patch 'RP055'
  owner 'tux'
  groupname 'tux_grp' 
end
```
### Attributes
```
node['common_artifact_repo'] = 'https://artifact.server/software'
```

### Common Artifact Repository
This cookbook uses a common artifact repository pattern. 
Artifacts urls will be generated in the following manner:

node['common_artifact_repo'] + vendor + product + version + file_as_named_by_vendor

eg. the above resource & attribute will attempt to retrieve artifacts from the following
locations:
```
https://artifact.server/software/oracle/tuxedo/12.1.1.0.0/tuxedo12110_64_linux_5.bin
https://artifact.server/software/oracle/tuxedo/12.1.1.0.0/RP055.tar.Z
```

Artifact urls can be overridden by specifying installer_url or patch_url on the
resource.

## License and Author

* Author: Dan Webb (<d.webb@derby.ac.uk>)
* Author: Luke Bradbury (<luke.bradbury@derby.ac.uk>)

Copyright: 2015, University of Derby

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
