.. _cli:

================================================================================
Command Line Interface
================================================================================

OpenNebula provides a set commands to interact with the system:

CLI
================================================================================

* `oneacct </doc/5.13/cli/oneacct.1.html>`__: gets accounting data from OpenNebula
* `oneacl </doc/5.13/cli/oneacl.1.html>`__: manages OpenNebula ACLs
* `onecluster </doc/5.13/cli/onecluster.1.html>`__: manages OpenNebula clusters
* `onedatastore </doc/5.13/cli/onedatastore.1.html>`__: manages OpenNebula datastores
* `onedb </doc/5.13/cli/onedb.1.html>`__: OpenNebula database migration tool
* `onegroup </doc/5.13/cli/onegroup.1.html>`__: manages OpenNebula groups
* `onehost </doc/5.13/cli/onehost.1.html>`__: manages OpenNebula hosts
* `oneimage </doc/5.13/cli/oneimage.1.html>`__: manages OpenNebula images
* `onetemplate </doc/5.13/cli/onetemplate.1.html>`__: manages OpenNebula templates
* `oneuser </doc/5.13/cli/oneuser.1.html>`__: manages OpenNebula users
* `onevdc </doc/5.13/cli/onevdc.1.html>`__: manages OpenNebula Virtual DataCenters
* `onevm </doc/5.13/cli/onevm.1.html>`__: manages OpenNebula virtual machines
* `onevnet </doc/5.13/cli/onevnet.1.html>`__: manages OpenNebula networks
* `onezone </doc/5.13/cli/onezone.1.html>`__: manages OpenNebula zones
* `onesecgroup </doc/5.13/cli/onesecgroup.1.html>`__: manages OpenNebula security groups
* `onevcenter </doc/5.13/cli/onevcenter.1.html>`__: handles vCenter resource import
* `onevrouter </doc/5.13/cli/onevrouter.1.html>`__: manages OpenNebula Virtual Routers
* `oneshowback </doc/5.13/cli/oneshowback.1.html>`__: OpenNebula Showback Tool
* `onemarket </doc/5.13/cli/onemarket.1.html>`__: manages internal and external Marketplaces
* `onemarketapp </doc/5.13/cli/onemarketapp.1.html>`__: manages appliances from Marketplaces


The output of these commands can be customized by modifying the configuration files that can be found in ``/etc/one/cli/``. They also can be customized on a per-user basis, in this case the configuration files should be placed in ``$HOME/.one/cli``.

List operation for each command will open a ``less`` session for a better user experience. First elements will be printed right away while the rest will begin to be requested and added to a cache, providing faster response times, specially on big deployments. Less session will automatically be canceled if a pipe is used for better interaction with scripts, providing the traditional, non interactive output.

OneFlow Commands
================================================================================

* `oneflow </doc/5.13/cli/oneflow.1.html>`__: OneFlow Service management
* `oneflow-template </doc/5.13/cli/oneflow-template.1.html>`__: OneFlow Service Template management

OneFlow Commands
================================================================================

* `onegate </doc/5.13/cli/oneflow.1.html>`__: OneGate Service management

