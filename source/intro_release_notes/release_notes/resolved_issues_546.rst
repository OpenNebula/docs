.. _resolved_issues_546:

Resolved Issues in 5.4.6
--------------------------------------------------------------------------------

A complete list of solved issues for 5.4.6 can be found in the `project development portal <https://github.com/OpenNebula/one/milestone/7?closed=1>`__ TODO change

The following issues has been solved in 5.4.6:

- `Monitoring error. Any stderr from virsh domblkstat command should be filtered <https://github.com/OpenNebula/one/issues/1524>`__.
- `Race condition in the datastore monitoring drivers <https://github.com/OpenNebula/one/issues/1361>`__.
- `Host overcommitment broken <https://github.com/OpenNebula/one/issues/1593>`__.
- `Image selection shouldn't list images in ERROR state <https://github.com/OpenNebula/one/issues/795>`__.
- `Cluster update dialog breaks RESERVED_* attributes <https://github.com/OpenNebula/one/issues/1468>`__.
- `Security Groups disabled when creating an Open vSwitch network <https://github.com/OpenNebula/one/issues/1491>`__.
- `Improve Network Topology <https://github.com/OpenNebula/one/issues/1517>`__.
- `Duplicated NIC when save a template <https://github.com/OpenNebula/one/issues/1600>`__.
- `Size error when instantiate vCenter template <https://github.com/OpenNebula/one/issues/1606>`__.
- `Collectd driver: Options are not properly parsed. Remove cache <https://github.com/OpenNebula/one/issues/1589>`__.
- `Added missing commands to onedb to manipulate history records <https://github.com/OpenNebula/one/issues/1614>`__.
- `VMGroup & DS datatables broken in vCenter Cloud View <https://github.com/OpenNebula/one/issues/1621>`__. If you are interested in adding a VMGroup or DS in vCenter Cloud View, you should make the following changes in ``/etc/one/sunstone-views/cloud_vcenter.yaml``:

 - https://github.com/OpenNebula/one/commit/d019485e3d69588a7645fe30114c3b7c135d3065
 - https://github.com/OpenNebula/one/commit/efdffc4723aae3d2b3f524a1e2bb27c81e43b13d

- `Error retrieve VMGroup <https://github.com/OpenNebula/one/issues/1619>`__.
- `Downloader may get too small VMDK part to estimate image size <https://github.com/OpenNebula/one/issues/1627>`__.
- `Added support for setting the CPU model <https://github.com/OpenNebula/one/issues/756>`__.
