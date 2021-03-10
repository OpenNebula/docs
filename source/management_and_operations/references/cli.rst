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

List operation for each command will open a ***less session*** for a better user experience. First elements will be printed right away while the rest will begin to be requested and added to a cache, providing faster response times, specially on big deployments. Less session will automatically be canceled if a pipe is used for better interaction with scripts, providing the traditional, non interactive output.	

ECONE Commands
================================================================================

* `econe-upload </doc/5.13/cli/econe-upload.1.html>`__: Uploads an image to OpenNebula
* `econe-describe-images </doc/5.13/cli/econe-describe-images.1.html>`__: Lists all registered images belonging to one particular user.
* `econe-run-instances </doc/5.13/cli/econe-run-instances.1.html>`__: Runs an instance of a particular image (that needs to be referenced).
* `econe-describe-instances </doc/5.13/cli/econe-describe-instances.1.html>`__: Outputs a list of launched images belonging to one particular user.
* `econe-terminate-instances </doc/5.13/cli/econe-terminate-instances.1.html>`__: Shutdowns a set of virtual machines (or cancel, depending on its state).
* `econe-reboot-instances </doc/5.13/cli/econe-reboot-instances.1.html>`__: Reboots a set of virtual machines.
* `econe-start-instances </doc/5.13/cli/econe-start-instances.1.html>`__: Starts a set of virtual machines.
* `econe-stop-instances </doc/5.13/cli/econe-stop-instances.1.html>`__: Stops a set of virtual machines.
* `econe-create-volume </doc/5.13/cli/econe-create-volume.1.html>`__: Creates a new DATABLOCK in OpenNebula
* `econe-delete-volume </doc/5.13/cli/econe-delete-volume.1.html>`__: Deletes an existing DATABLOCK.
* `econe-describe-volumes </doc/5.13/cli/econe-describe-volumes.1.html>`__: Describe all available DATABLOCKs for this user
* `econe-attach-volume </doc/5.13/cli/econe-attach-volume.1.html>`__: Attaches a DATABLOCK to an instance
* `econe-detach-volume </doc/5.13/cli/econe-detach-volume.1.html>`__: Detaches a DATABLOCK from an instance
* `econe-allocate-address </doc/5.13/cli/econe-allocate-address.1.html>`__: Allocates a new elastic IP address for the user
* `econe-release-address </doc/5.13/cli/econe-release-address.1.html>`__: Releases a publicIP of the user
* `econe-describe-addresses </doc/5.13/cli/econe-describe-addresses.1.html>`__: Lists elastic IP addresses
* `econe-associate-address </doc/5.13/cli/econe-associate-address.1.html>`__: Associates a publicIP of the user with a given instance
* `econe-disassociate-address </doc/5.13/cli/econe-disassociate-address.1.html>`__: Disasociate a publicIP of the user currently associated with an instance
* `econe-create-keypair </doc/5.13/cli/econe-create-keypair.1.html>`__: Creates the named keypair
* `econe-delete-keypair </doc/5.13/cli/econe-delete-keypair.1.html>`__: Deletes the named keypair, removes the associated keys
* `econe-describe-keypairs </doc/5.13/cli/econe-describe-keypairs.1.html>`__: List and describe the key pairs available to the user
* `econe-register </doc/5.13/cli/econe-register.1.html>`__: Registers an image

OneFlow Commands
================================================================================

* `oneflow </doc/5.13/cli/oneflow.1.html>`__: OneFlow Service management
* `oneflow-template </doc/5.13/cli/oneflow-template.1.html>`__: OneFlow Service Template management

OneFlow Commands
================================================================================

* `onegate </doc/5.13/cli/oneflow.1.html>`__: OneGate Service management

