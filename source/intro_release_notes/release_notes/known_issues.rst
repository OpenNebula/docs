.. _known_issues:

================================================================================
Known Issues
================================================================================

CLI
================================================================================

* `#781 <https://github.com/OpenNebula/one/issues/781>`_ Different ruby versions need different time formats
* `#841 <https://github.com/OpenNebula/one/issues/841>`_ Wrong headers when output is piped for oneacct and oneshowback

Drivers - Network
================================================================================

* `#954 <https://github.com/OpenNebula/one/issues/954>`_ NIC defaults not honoured in attach NIC

Drivers - Storage
================================================================================

* `#2246 <https://github.com/OpenNebula/one/issues/2246>`_ VMs created from images inside a Ceph datastore with EC_POOL_NAME are not created in that EC pool
* `#1286 <https://github.com/OpenNebula/one/issues/1286>`_ Can not flatten image without losing latest state
* `#1955 <https://github.com/OpenNebula/one/issues/1955>`_ Only 1 Ceph monitor added in libvirt XML when Ceph DISK IMAGE attached (hot-add)

Drivers - VM
================================================================================

* `#1157 <https://github.com/OpenNebula/one/issues/1157>`_ Signal timeouts in EC2 driver

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

Marketplace
================================================================================

* `#1159 <https://github.com/OpenNebula/one/issues/1159>`_ DISPOSE=YES in market_mad/remotes/http/import is not honored

Sunstone
================================================================================

* `#636 <https://github.com/OpenNebula/one/issues/636>`_ if syslog enabled disable the logs tab in the VM detailed view
* `#916 <https://github.com/OpenNebula/one/issues/916>`_ Sunstone ignores the no_proxy environment variable
* `#1532 <https://github.com/OpenNebula/one/issues/1532>`_ Sunstone is killed by OOM Killer when uploading large images
* `#2412: <https://github.com/OpenNebula/one/issues/2412>`_ Poweroff all VM on the host provides bridge interface disable
* `#1662: <https://github.com/OpenNebula/one/issues/1662>`_ Showback hours slightly innacurate

vCenter
================================================================================

* `#2275 <https://github.com/OpenNebula/one/issues/2275>`_ Remove disk not affected by snap on vCenter
* `#2530 <https://github.com/OpenNebula/one/issues/2530>`_ StorageDRS is not working properly

