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

Drivers - Network
================================================================================

* `#792 <https://github.com/OpenNebula/one/issues/792>`_ Review the Open vSwitch flows
* `#954 <https://github.com/OpenNebula/one/issues/954>`_ NIC defaults not honoured in attach NIC

Drivers - Storage
================================================================================

* `#944 <https://github.com/OpenNebula/one/issues/944>`_ CEPH_HOST not IPv6 friendly
* `#2269 <https://github.com/OpenNebula/one/issues/2269>`_ Clonning images from one Ceph datastore to another
* `#2246 <https://github.com/OpenNebula/one/issues/2246>`_ VMs created from images inside a Ceph datastore with EC_POOL_NAME are not created in that EC pool

Drivers - VM
================================================================================


Drivers - Auth
================================================================================

* `#1761 <https://github.com/OpenNebula/one/issues/1761>`_ RAFT sync leads to Duplicate key on case sensitive login

Packages
================================================================================

* `#1703 <https://github.com/OpenNebula/one/issues/1703>`_ Can't attach disk after detaching disk

OneFlow
================================================================================

* `#917 <https://github.com/OpenNebula/one/issues/917>`_ oneflow and oneflow-template ignore the no_proxy environment variable
* `#668 <https://github.com/OpenNebula/one/issues/668>`_ Scheduled policy start_time cannot be defined as a POSIX time number
* `#1077 <https://github.com/OpenNebula/one/issues/1077>`_ Throw an error an error if a template update is invalid

Marketplace
================================================================================

* `#1159 <https://github.com/OpenNebula/one/issues/1159>`_ DISPOSE=YES in market_mad/remotes/http/import is not honored

Scheduler
================================================================================

* `#629 <https://github.com/OpenNebula/one/issues/629>`_ If more than one scheduled actions fit in a scheduler cycle, the behavior is unexpected

Sunstone
================================================================================

* `#636 <https://github.com/OpenNebula/one/issues/636>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#916 <https://github.com/OpenNebula/one/issues/916>`_ sunstone ignores the no_proxy environment variable

vCenter
================================================================================

* `#1350 <https://github.com/OpenNebula/one/issues/1350>`_ Template delete recursive operation of templates **instantiated as persistent** does not remove images from the vcenter datastores. Currently these files must be delete manually
* `#2230 <https://github.com/OpenNebula/one/issues/2230>`_ vCenter driver migrate feedback
* `#2275 <https://github.com/OpenNebula/one/issues/2275>`_ Remove disk not affected by snap on vCenter
* `#2274 <https://github.com/OpenNebula/one/issues/2274>`_ Remove CDROM from imported template
* `#2254 <https://github.com/OpenNebula/one/issues/2254>`_ spurios syntax help on onehost delete
* `#2262 <https://github.com/OpenNebula/one/issues/2262>`_ Wait poweron/off to be performed
* `#1626 <https://github.com/OpenNebula/one/issues/1626>`_ vCenter importer lock file stale and clash
* `#2084 <https://github.com/OpenNebula/one/issues/2084>`_ vCenter Cache thread safe (thin related)
