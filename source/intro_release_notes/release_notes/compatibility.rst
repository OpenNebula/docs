
.. _compatibility:

====================
Compatibility Guide
====================

This guide is aimed at OpenNebula 6.1.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the :ref:`corresponding section <upgrade>`.

The following components have been deprecated:

 - ECONE server (implementing EC2Query REST interface) is no longer available.
 - Hybrid drivers for Amazon EC2 and Microsoft Azure, as well as the hybrid connection to remote OpenNebula instances, are no longer available. The preferred mechanism to grow your cloud with public cloud providers is through the :ref:`Edge Cluster Provisioning <first_edge_cluster>`.

Visit the :ref:`Features list <features>` and the :ref:`What's New guide <whats_new>` for a comprehensive list of what's new in OpenNebula 6.1.

HTTP_PROXY and XMLRPC API
=========================
Scheduler clears the http_proxy environment variable. If your oned xml-rpc API is behind an HTTP_PROXY you need to update ``sched.conf`` and set the right value there.

Ruby API
========

Some functions has been moved from API to new API extensions:

- save_as_template

To be able to use them, you need to extend from the extensions file:

.. code::

    require 'opennebula/virtual_machine_ext'

    vm_new = VirtualMachine.new(VirtualMachine.build_xml(@pe_id), @client)
    vm_new.extend(VirtualMachineExt)

Distributed Edge Provisioning
=============================

Information about provision is stored in a JSON document. For this reason, the ERB evaluation must be done using the variable ``@body['provision']``.

To access infrastructure resources, just key ``infrastructure`` followed by the object, e.g.:

.. code::

    @body['provision']['infrastructure']['datastores'][0]['id']

To access resources, just key ``resource`` followed by the object, e.g.:

.. code::

    @body['provision']['resource']['images'][0]['id']

Check more information :ref:`here <ddc_virtual>`.

In the provision template, the attribute ``driver`` has be changed to ``provider``.

The driver EC2 has been renamed to AWS to follow Terraform provider name. Consequently, the keys have been renamed in the following way:

- ec2_access -> access_key
- ec2_secret -> secret_key
- region_name -> region

Provision drivers have been changed by Terraform, so the following commands are no longer available:

- ``oneprovision host resume``
- ``oneprovision host poweroff``
- ``oneprovision host reboot``
- ``oneprovision host reboot --hard``

Datastore Driver Changes
=============================

   - Now, the CP datastore action also needs to return the format of the file copied (e.g raw or qcow2). This way, when a file is uploaded by the user, the format of the file is automatically retrieved, avoiding user mistakes.

   - The ``DRIVER`` and ``FSTYPE`` attributes are deprecated and they won't be taken into account any more.

.. note:: The ``DRIVER`` attribute will be set automatically for each disk.

.. _compatibility_kvm:

KVM Driver Defaults Changed
===========================

The KVM driver comes with new defaults, which better reflect the modern use of this technology (e.g., leverage paravirtualized interfaces or rely more on QEMU guest agent). Consult the current defaults in the following vanilla configuration files provided with OpenNebula:

- ``/etc/one/vmm_exec/vmm_exec_kvm.conf``
- ``/var/lib/one/remotes/etc/vmm/kvm/kvmrc``

The default path to QEMU emulator (parameter ``EMULATOR`` in ``/etc/one/vmm_exec/vmm_exec_kvm.conf``) has changed from a distribution specific-path to a unified symbolic link ``/usr/bin/qemu-kvm-one``. This is created on hypervisors during the installation of a KVM node package and points to the QEMU binary of each node's operating system.

.. _compatibility_pkg:

Distribution Packages Renamed
=============================

The names of the main distribution packages were unified across the distributions to eliminate differences and avoid confusion. Users might need to update their custom scripts (e.g., their own Ansible installation tasks, Dockerfiles) to deal with new packages. Upgrades of existing deployments shouldn't be negatively affected as the deprecations are automatically handled by the package managers.

On CentOS/RHEL the renamed packages are

* **opennebula** (formerly CLI tools) to **opennebula-tools**
* **opennebula-server** (formerly OpenNebula daemon and scheduler) to **opennebula**
* **opennebula-ruby** to **opennebula-libs**

On Debian/Ubuntu the renamed packages are

* **opennebula-node** to **opennebula-node-kvm**
* **ruby-opennebula** to **opennebula-libs**

See the curent :ref:`list of shipped packages <packages>`.

.. _compatibility_sunstone:

Sunstone SELinux Requirement
=============================

Now OCA, and therefore Sunstone, need `zmq gem <https://rubygems.org/gems/zmq>`__, and for that you need to enable the ``httpd_execmem`` SELinux boolean.


Custom Datastore drivers
========================
The custom :ref:`Datastore Driver <sd>`, which uses ``DISPOSE="YES"`` in the export, now needs to also add ``<DISPOSE_CMD></DISPOSE_CMD>`` with the command to remove the temporary file by the :ref:`Market Driver <devel-market>`.

NIC Names
=========
NIC names in the format ``NIC<number>`` are reserved for internal use. User NIC names in this format will be prefixed with ``_``

LXD
========================

.. _lxd_compatibility:

In OpenNebula 6.0 LXD VMM Driver have been deprecated in favor of LXC driver. The replacement of the LXD driver by LXC has the following implications:

   - LXC has less runtime dependencies and overhead.
   - LXC can be easily upgraded to new versions. OpenNebula and LXD management of underlying storage conflicts and the 3.0 model are no longer supported.
   - LXC is supported by more OS distributions.

Current Limitations of LXC vs LXD
-----------------------------------

   - In order to improve the security, LXC will only support unprivileged containers.
   - Any LXD feature (e.g container profiles) is not supported.
   - LXC only supports file system images (e.g. multipart images are not supported anymore for containers).
   - Support for wild container is not implemented yet.
   - Support for custom disk mountpoints is not implemented yet.
   - The current list of LXC unsupported actions can be found :ref:`here <lxc_unsupported_actions>`.

.. note:: Some of these limitations will be implemented depending on the users' needs and the roadmap definition.

LXD to LXC Migration Strategy
-----------------------------------

From OpenNebula 6.0, LXD drivers will be deprecated but they will still be supported. The aim of this is to provide our users a period of time to define their migration strategy during which they can run both kinds of containers.

Specific information on how to carry out the migration can be found in the :ref:`LXD to LXC Migration guide <lxd_to_lxc>`.
