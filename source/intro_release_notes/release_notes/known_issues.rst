.. _known_issues:

================================================================================
Known Issues
================================================================================

CLI
================================================================================

* `#781 <https://github.com/OpenNebula/one/issues/781>`_ Different ruby versions need different time formats
* `#841 <https://github.com/OpenNebula/one/issues/841>`_ Wrong headers when output is piped for oneacct and oneshowback

Core & System
================================================================================

* `#937 <https://github.com/OpenNebula/one/issues/937>`_ An image can be used twice by a VM, but this breaks the used/ready logic
* `#1243 <https://github.com/OpenNebula/one/issues/1243>`_ Hybrid VMs in poweroff --> terminate are not removed from public cloud provider
* `#1184 <https://github.com/OpenNebula/one/issues/1184>`_ PUBLIC_CLOUD variables do not accept ','
* `#763 <https://github.com/OpenNebula/one/issues/763>`_ If an user removes USE or MANAGE rights from VM it cannot access it anymore
* `#2260 <https://github.com/OpenNebula/one/issues/2260>`_ Re-evaluate the actions that can be supported by a Virtual Router
* `#1815 <https://github.com/OpenNebula/one/issues/1815>`_ Remove resource references from VDC when erased
* `#1255 <https://github.com/OpenNebula/one/issues/1255>`_ MANAGE right requirement on image for disk snapshot unjustified with ceph
* `#1635 <https://github.com/OpenNebula/one/issues/1635>`_ Do not instantiate VM if IP is allocated
* `#1320 <https://github.com/OpenNebula/one/issues/1320>`_ Implement call to let raft know that a follower's db has been updated
* `#1312 <https://github.com/OpenNebula/one/issues/1312>`_ VM Save As - Disk advanced params not saved to new template
* `#1395 <https://github.com/OpenNebula/one/issues/1395>`_ Deleting a group that owns images used by running VMs breaks those VMs
* `#2284 <https://github.com/OpenNebula/one/issues/2284>`_ Quotas assignment error

Drivers - Network
================================================================================

* `#792 <https://github.com/OpenNebula/one/issues/792>`_ Review the Open vSwitch flows
* `#954 <https://github.com/OpenNebula/one/issues/954>`_ NIC defaults not honoured in attach NIC

Drivers - Storage
================================================================================

* `#944 <https://github.com/OpenNebula/one/issues/944>`_ CEPH_HOST not IPv6 friendly
* `#2269 <https://github.com/OpenNebula/one/issues/2269>`_ Clonning images from one Ceph datastore to another
* `#2246 <https://github.com/OpenNebula/one/issues/2246>`_ VMs created from images inside a Ceph datastore with EC_POOL_NAME are not created in that EC pool
* `#1286 <https://github.com/OpenNebula/one/issues/1286>`_ Can not flatten image without losting latest state
* `#1955 <https://github.com/OpenNebula/one/issues/1955>`_ Only 1 Ceph monitor added in libvirt XML when Ceph DISK IMAGE attached (hot-add)

Drivers - VM
================================================================================

* `#1157 <https://github.com/OpenNebula/one/issues/1157>`_ Signal timeouts in EC2 driver
* `#1309 <https://github.com/OpenNebula/one/issues/1309>`_ Improve exception handling azure and ec2 drivers

Drivers - Auth
================================================================================

* `#1761 <https://github.com/OpenNebula/one/issues/1761>`_ RAFT sync leads to Duplicate key on case sensitive login

Packages
================================================================================

* `#1703 <https://github.com/OpenNebula/one/issues/1703>`_ Can't attach disk after detaching disk
* `#1650 <https://github.com/OpenNebula/one/issues/1650>`_ Discrepancies between Opennebula's tarball and the the Github one
* `#820 <https://github.com/OpenNebula/one/issues/820>`_ Debian package ruby-opennebula doesn't place files into GEM_PATH
* `#1225 <https://github.com/OpenNebula/one/issues/1225>`_ OneGate Server package is not provided needed gems or install_gems script

OneFlow
================================================================================

* `#917 <https://github.com/OpenNebula/one/issues/917>`_ oneflow and oneflow-template ignore the no_proxy environment variable
* `#668 <https://github.com/OpenNebula/one/issues/668>`_ Scheduled policy start_time cannot be defined as a POSIX time number
* `#1077 <https://github.com/OpenNebula/one/issues/1077>`_ Throw an error if a template update is invalid

Marketplace
================================================================================

* `#1159 <https://github.com/OpenNebula/one/issues/1159>`_ DISPOSE=YES in market_mad/remotes/http/import is not honored
* `#1666 <https://github.com/OpenNebula/one/issues/1666>`_ Marketplace driver expects always an image to import

Scheduler
================================================================================

* `#629 <https://github.com/OpenNebula/one/issues/629>`_ If more than one scheduled actions fit in a scheduler cycle, the behavior is unexpected

Sunstone
================================================================================

* `#636 <https://github.com/OpenNebula/one/issues/636>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#916 <https://github.com/OpenNebula/one/issues/916>`_ Sunstone ignores the no_proxy environment variable
* `#1532 <https://github.com/OpenNebula/one/issues/1532>`_ Sunstone is killed by OOM Killer when uploading large images

vCenter
================================================================================

* `#2672 <https://github.com/OpenNebula/one/issues/2672>`_ Snapshots are not working properly
* `#2275 <https://github.com/OpenNebula/one/issues/2275>`_ Remove disk not affected by snap on vCenter
* `#2254 <https://github.com/OpenNebula/one/issues/2254>`_ spurios syntax help on onehost delete
* `#2084 <https://github.com/OpenNebula/one/issues/2084>`_ vCenter Cache thread safe (thin related)
* `#2530 <https://github.com/OpenNebula/one/issues/2530>`_ StorageDRS is not working properly
* `#1699 <https://github.com/OpenNebula/one/issues/1699>`_ Wild VM monitoring should not return datastores that contain only swap files
* `#1259 <https://github.com/OpenNebula/one/issues/1259>`_ Premigrator: unmanaged nics from vms are outside the AR of the network
