.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided on our site is the recommended method, to ensure the installation of the latest version and to avoid possible package divergences in different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://usela.io/use>`__ to **download the latest package** for your Linux distribution.

.. _kvm_repo:

Step 1. Add OpenNebula Repositories
===================================

Refer to this :ref:`guide <repositories>` to add the community or enterprise edition repositories.

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

.. include:: ../../quick_start/opennebula_installation/epel.txt

Install Node Package
^^^^^^^^^^^^^^^^^^^^

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo yum install opennebula-node-kvm
    $ sudo systemctl restart libvirtd

Optional: Newer QEMU/KVM (only CentOS/RHEL 7)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may benefit from using the more recent and feature-rich enterprise QEMU/KVM release. The differences between the base (``qemu-kvm``) and enterprise (``qemu-kvm-rhev`` on RHEL or ``qemu-kvm-ev`` on CentOS) packages are described on the `Red Hat Customer Portal <https://access.redhat.com/solutions/629513>`__.

On **CentOS 7**, the enterprise packages are part of the separate repository. To replace the base packages, follow these steps:

.. prompt:: bash $ auto

    $ sudo yum install centos-release-qemu-ev
    $ sudo yum install qemu-kvm-ev

On **RHEL 7**, you need a paid subscription to the Red Hat Virtualization (RHV) or Red Hat OpenStack (RHOS) products license only for the Red Hat Enterprise Linux isn't enough! You have to check the RHV `Installation Guide <https://access.redhat.com/documentation/en-us/red_hat_virtualization/>`__ for your licensed version. Usually, the following commands should enable and install the enterprise packages:

.. prompt:: bash $ auto

    $ sudo subscription-manager repos --enable rhel-7-server-rhv-4-mgmt-agent-rpms
    $ sudo yum install qemu-kvm-rhev

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula-provided configuration file:

.. prompt:: bash $ auto

    $ sudo apt-get update
    $ sudo apt-get install opennebula-node-kvm
    $ sudo service libvirtd restart # debian
    $ sudo service libvirt-bin restart # ubuntu

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

.. _kvm_selinux:

Step 3. SELinux on CentOS/RHEL
==============================

.. warning::
    If you are performing an upgrade skip this and the next steps and go back to the upgrade document.

SELinux can block some operations initiated by the OpenNebula Front-end, resulting in all the node operations failing completely (e.g., when the ``oneadmin`` user's SSH credentials are not trusted) or only individual failures for particular operations with virtual machines. If the administrator isn't experienced in SELinux configuration, **it's recommended to disable this functionality to avoid unexpected failures**. You can enable SELinux anytime later when you have the installation working.

Disable SELinux (recommended)
-----------------------------

Change the following line in ``/etc/selinux/config`` to **disable** SELinux:

.. code-block:: bash

    SELINUX=disabled

After the change, you have to reboot the machine.

Enable SELinux
--------------

Change the following line in ``/etc/selinux/config`` to enable SELinux in ``enforcing`` state:

.. code-block:: bash

    SELINUX=enforcing

When changing from the ``disabled`` state, it's necessary to trigger filesystem relabel on the next boot by creating a file ``/.autorelabel``, e.g.:

.. prompt:: bash $ auto

    $ touch /.autorelabel

After the changes, you should reboot the machine.

.. note:: Depending on your OpenNebula deployment type, the following may be required on your SELinux-enabled KVM nodes:

    * package ``util-linux`` newer than 2.23.2-51 installed
    * SELinux boolean ``virt_use_nfs`` enabled (with datastores on NFS):

    .. prompt:: bash $ auto

        $ sudo setsebool -P virt_use_nfs on

    Follow the `SELinux User's and Administrator's Guide <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/selinux_users_and_administrators_guide/>`__ for more information on how to configure and troubleshoot SELinux.

.. _kvm_ssh:

Step 4. Configure Passwordless SSH
==================================

The OpenNebula Front-end connects to the hypervisor Hosts using SSH. Following connection types are being established:

- from Front-end to Front-end,
- from Front-end to hypervisor Host,
- from Front-end to hypervisor Host with another connection within to another Host (for migration operations),
- from Front-end to hypervisor Host with another connection within back to Front-end (for data copy back).

.. important::

    It must be ensured that Front-end and all Hosts **can connect to each other** over SSH without manual intervention.

When OpenNebula server package is installed on the Front-end, a SSH key pair is automatically generated for the *oneadmin* user into ``/var/lib/one/.ssh/id_rsa`` and ``/var/lib/one/.ssh/id_rsa.pub``, the public key is also added into ``/var/lib/one/.ssh/authorized_keys``. It happens only if these files don't exist yet, existing files (e.g., leftovers from previous installations) are not touched! For new installations, the :ref:`default SSH configuration <node_ssh_config>` is placed for the *oneadmin* from ``/usr/share/one/ssh`` into ``/var/lib/one/.ssh/config``.

To enable passwordless connections you must distribute the public key of the *oneadmin* user from the Front-end to ``/var/lib/one/.ssh/authorized_keys`` on all hypervisor Hosts. There are many methods to achieve the distribution of the SSH keys. Ultimately the administrator should choose a method; the recommendation is to use a configuration management system (e.g., Ansible or Puppet). In this guide, we are going to manually use SSH tools.

**Since OpenNebula 5.12**. On the Front-end runs dedicated **SSH authentication agent** service which imports the *oneadmin*'s private key on its start. Access to this agent is delegated (forwarded) from the OpenNebula Front-end to the hypervisor Hosts for the operations which need to connect between Hosts or back to the Front-end. While the authentication agent is used, you **don't need to distribute private SSH key from Front-end** to hypervisor Hosts!

To learn more about the SSH, read the :ref:`Advanced SSH Usage <node_ssh>` guide.

.. _kvm_ssh_known_hosts:

A. Populate Host SSH Keys
-------------------------

You should prepare and further manage the list of host SSH public keys of your nodes (a.k.a. ``known_hosts``) so that all communicating parties know the identity of the other sides. The file is located in ``/var/lib/one/.ssh/known_hosts`` and we can use the command ``ssh-keyscan`` to manually create it. It should be executed on your Front-end under *oneadmin* user and copied on all your Hosts.

.. important::

   You'll need to update and redistribute file with host keys every time any host is reinstalled or its keys are regenerated.

.. important::

   If :ref:`default SSH configuration <node_ssh_config>` shipped with OpenNebula is used, the SSH client automatically accepts host keys on the first connection. That makes this step optional, as the ``known_hosts`` will be incrementally automatically generated on your infrastructure when the various connections happen. While this simplifies the initial deployment, it lowers the security of your infrastructure. We highly recommend to populate ``known_hosts`` on your infrastructure in controlled manner!

Make sure you are logged on your Front-end and run the commands as *oneadmin*, e.g. by typing:

.. prompt:: bash $ auto

    # su - oneadmin

Create the ``known_hosts`` file by running following command with all the Host names including the Front-end as parameters:

.. prompt:: bash $ auto

    $ ssh-keyscan <frontend> <node1> <node2> <node3> ... >> /var/lib/one/.ssh/known_hosts

B. Distribute Authentication Configuration
------------------------------------------

To enable passwordless login on your infrastructure, you must copy authentication configuration for *oneadmin* user from Front-end to all your nodes. We'll distribute only ``known_hosts`` created in the previous section and *oneadmin*'s SSH public key from Front-end to your nodes. We **don't need to distribute oneadmin's SSH private key** from Front-end, as it'll be securely delegated from Front-end to hypervisor Hosts with the default **SSH authentication agent** service running on the Front-end.

Make sure you are logged on your Front-end and run the commands as *oneadmin*, e.g. by typing:

.. prompt:: bash $ auto

    # su - oneadmin

Enable passwordless logins by executing the following command for each your Host. For example:

.. prompt:: bash $ auto

    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub <node1>
    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub <node2>
    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub <node3>

If the list of host SSH public keys was created in the previous section, distribute the ``known_hosts`` file on each your Host. For example:

.. prompt:: bash $ auto

    $ scp -p /var/lib/one/.ssh/known_hosts <node1>:/var/lib/one/.ssh/
    $ scp -p /var/lib/one/.ssh/known_hosts <node2>:/var/lib/one/.ssh/
    $ scp -p /var/lib/one/.ssh/known_hosts <node3>:/var/lib/one/.ssh/

Without SSH Authentication Agent (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

    **Not Recommended**. If you don't use integrated SSH authentication agent service (which is initially enabled) on the Front-end, you'll have to distribute also *oneadmin*'s private SSH key on your hypervisor Hosts to allow connections among Hosts and from Hosts to Front-end. For security reasons, it's recommended to use SSH authentication agent service and **avoid this step**.

    If you need to distribute *oneadmin*'s private SSH key on your Hosts, proceeed with steps above and continue with following extra commands for all your Hosts. For example:

    .. prompt:: bash $ auto

        $ scp -p /var/lib/one/.ssh/id_rsa <node1>:/var/lib/one/.ssh/
        $ scp -p /var/lib/one/.ssh/id_rsa <node2>:/var/lib/one/.ssh/
        $ scp -p /var/lib/one/.ssh/id_rsa <node3>:/var/lib/one/.ssh/

C. Validate Connections
-----------------------

You should verify that none of these connections (under user *oneadmin*) fail and none require password:

* from the Front-end to Front-end itself
* from the Front-end to all Hosts
* from all Hosts to all Hosts
* from all Hosts back to Front-end

For example, execute on the Front-end:

.. prompt:: bash $ auto

    # from Front-end to Front-end itself
    $ ssh <frontend>
    $ exit

    # from Front-end to node, back to Front-end and to other nodes
    $ ssh <node1>
    $ ssh <frontend>
    $ exit
    $ ssh <node2>
    $ exit
    $ ssh <node3>
    $ exit
    $ exit

    # from Front-end to node, back to Front-end and to other nodes
    $ ssh <node2>
    $ ssh <frontend>
    $ exit
    $ ssh <node1>
    $ exit
    $ ssh <node3>
    $ exit
    $ exit

    # from Front-end to nodes and back to Front-end and other nodes
    $ ssh <node3>
    $ ssh <frontend>
    $ exit
    $ ssh <node1>
    $ exit
    $ ssh <node2>
    $ exit
    $ exit

.. _kvm_node_networking:

.. _kvm_net:

Step 5. Networking Configuration
================================

.. image:: /images/network-02.png
    :width: 30%
    :align: center


A network connection is needed by the OpenNebula Front-end daemons to access the hosts to manage and monitor the Hosts, and to transfer the Image files. It is highly recommended to use a dedicated network for this purpose.

There are various network models. Please check the :ref:`Networking <nm>` chapter to find out the networking technologies supported by OpenNebula.

You may want to use the simplest network model, that corresponds to the :ref:`bridged <bridged>` driver. For this driver, you will need to setup a Linux bridge and include a physical device in the bridge. Later on, when defining the network in OpenNebula, you will specify the name of this bridge and OpenNebula will know that it should connect the VM to this bridge, thus giving it connectivity with the physical network device connected to the bridge. For example, a typical host with two physical networks, one for public IP addresses (attached to an ``eth0`` NIC for example) and the other for private virtual LANs (NIC ``eth1`` for example) should have two bridges:

.. prompt:: bash $ auto

    $ ip link show type bridge
    4: br0: ...
    5: br1: ...

    $ ip link show master br0
    2: eth0: ...

    $ ip link show master br1
    3: eth1: ...

.. note:: Remember that this is only required in the Hosts, not in the Front-end. Also remember that the exact name of the resources is not important (``br0``, ``br1``, etc...), however it's important that the bridges and NICs have the same name in all the Hosts.

.. _kvm_storage:

Step 6. Storage Configuration
=============================

You can skip this step entirely if you just want to try out OpenNebula, as it will come configured by default in such a way that it uses the local storage of the Front-end to store Images, and the local storage of the hypervisors as storage for the running VMs.

However, if you want to set-up another storage configuration at this stage, like Ceph, NFS, LVM, etc, you should read the :ref:`Open Cloud Storage <storage>` chapter.

.. _kvm_addhost:

Step 7. Adding a Host to OpenNebula
=============================================

In this step we will register the node we have installed in the OpenNebula Front-end, so OpenNebula can launch VMs in it. This step can be done in the CLI **or** in Sunstone, the graphical user interface. Follow just one method, not both, as they accomplish the same.

To learn more about the host subsystem, read :ref:`this guide <hostsubsystem>`.

Adding a Host through Sunstone
--------------------------------------------------------------------------------

Open Sunstone as documented :ref:`here <verify_frontend_section_sunstone>`. In the left side menu go to Infrastructure -> Hosts. Click on the ``+`` button.

|sunstone_select_create_host|

Then fill-in the fqdn of the node in the Hostname field.

|sunstone_create_host_dialog|

Finally, return to the Hosts list, and check that the Host has switched to ON status. It should take somewhere between 20s to 1m. Try clicking on the refresh button to check the status more frequently.

|sunstone_list_hosts|

If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

Adding a Host through the CLI
--------------------------------------------------------------------------------

To add a node to the cloud, run this command as ``oneadmin`` in the Front-end:

.. prompt:: bash $ auto

    $ onehost create <node01> -i kvm -v kvm

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       1 localhost       default     0                  -                  - init

    # After some time (20s - 1m)

    $ onehost list
      ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
       0 node01          default     0       0 / 400 (0%)     0K / 7.7G (0%) on

If the host turns to ``err`` state instead of ``on``, check ``/var/log/one/oned.log``. Chances are it's a problem with SSH!

.. _kvm_wild:

Step 8. Import Currently Running VMs (Optional)
===============================================

You can skip this step, as importing VMs can be done at any moment. However, if you wish to see your previously-deployed VMs in OpenNebula you can use the :ref:`import VM <import_wild_vms>` functionality.

.. _kvm_next:

Step 9. Next steps
================================================================================

You can now jump to the optional :ref:`Verify your Installation <verify_installation>` section in order to launch a test VM.

Otherwise, you are ready to :ref:`start using your cloud <operation_guide>` or you could configure more components:

* :ref:`Authentication <authentication>`. (Optional) For integrating OpenNebula with LDAP/AD, or securing it further with other authentication technologies.
* :ref:`Sunstone <sunstone>`. The OpenNebula GUI should be working and accessible at this stage, but by reading this guide you will learn about specific enhanced configurations for Sunstone.
* :ref:`Open Cloud Host Setup <vmmg>`.
* :ref:`Open Cloud Storage Setup <storage>`.
* :ref:`Open Cloud Networking Setup <nm>`.

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png
