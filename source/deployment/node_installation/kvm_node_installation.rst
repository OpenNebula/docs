.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided in our site is the recommended method, to ensure the installation of the latest version and to avoid possible packages divergences of different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.org/software:software>`__ to **download the latest package** for your Linux distribution.

.. _kvm_repo:

Step 1. Add OpenNebula Repositories
===================================

.. include:: ../repositories.txt

Step 2. Installing the Software
===============================

Installing on CentOS/RHEL
-------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo yum install opennebula-node-kvm
    $ sudo systemctl restart libvirtd

.. note:: You may benefit from using the more recent and feature-rich enterprise QEMU/KVM release. The differences between the base (``qemu-kvm``) and enterprise (``qemu-kvm-rhev`` on RHEL or ``qemu-kvm-ev`` on CentOS) packages are described on the `Red Hat Customer Portal <https://access.redhat.com/solutions/629513>`__.

    On CentOS 7, the enterprise packages are part of the separate repository. To replace the base packages, follow these steps:

    .. prompt:: bash $ auto

        $ sudo yum install centos-release-qemu-ev
        $ sudo yum install qemu-kvm-ev

    On RHEL, you need a paid subscription to the Red Hat Virtualization (RHV) or Red Hat OpenStack (RHOS) products. Please follow the RHV `Installation Guide <https://access.redhat.com/documentation/en-us/red_hat_virtualization/>`__.

For further configuration, check the specific guide: :ref:`KVM <kvmg>`.

Installing on Debian/Ubuntu
---------------------------

Execute the following commands to install the node package and restart libvirt to use the OpenNebula provided configuration file:

.. prompt:: bash $ auto

    $ sudo apt-get install opennebula-node
    $ sudo service libvirtd restart # debian
    $ sudo service libvirt-bin restart # ubuntu

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

Step 3. Disable SElinux in CentOS/RHEL 7
========================================

.. warning::
    If you are performing an upgrade skip this and the next steps and go back to the upgrade document.

SElinux can cause some problems, like not trusting ``oneadmin`` user's SSH credentials. You can disable it changing in the file ``/etc/selinux/config`` this line:

.. code-block:: bash

    SELINUX=disabled

After this file is changed reboot the machine.

.. _kvm_ssh:

Step 4. Configure Passwordless SSH
==================================

OpenNebula Front-end connects to the hypervisor Hosts using SSH. You must distribute the public key of ``oneadmin`` user from all machines to the file ``/var/lib/one/.ssh/authorized_keys`` in all the machines. There are many methods to achieve the distribution of the SSH keys, ultimately the administrator should choose a method (the recommendation is to use a configuration management system). In this guide we are going to manually scp the SSH keys.

When the package was installed in the Front-end, an SSH key was generated and the ``authorized_keys`` populated. We will sync the ``id_rsa``, ``id_rsa.pub`` and ``authorized_keys`` from the Front-end to the nodes. Additionally we need to create a ``known_hosts`` file and sync it as well to the nodes. To create the ``known_hosts`` file, we have to execute this command as user ``oneadmin`` in the Front-end with all the node names and the Front-end name as parameters:

.. prompt:: bash $ auto

    $ ssh-keyscan <frontend> <node1> <node2> <node3> ... >> /var/lib/one/.ssh/known_hosts

Now we need to copy the directory ``/var/lib/one/.ssh`` to all the nodes. The easiest way is to set a temporary password to ``oneadmin`` in all the hosts and copy the directory from the Front-end:

.. prompt:: bash $ auto

    $ scp -rp /var/lib/one/.ssh <node1>:/var/lib/one/
    $ scp -rp /var/lib/one/.ssh <node2>:/var/lib/one/
    $ scp -rp /var/lib/one/.ssh <node3>:/var/lib/one/
    $ ...

You should verify that connecting from the Front-end, as user ``oneadmin``, to the nodes and the Front-end itself, and from the nodes to the Front-end, does not ask password:

.. prompt:: bash $ auto

    $ ssh <frontend>
    $ exit

    $ ssh <node1>
    $ ssh <frontend>
    $ exit
    $ exit

    $ ssh <node2>
    $ ssh <frontend>
    $ exit
    $ exit

    $ ssh <node3>
    $ ssh <frontend>
    $ exit
    $ exit

.. _kvm_node_networking:

If an extra layer of security is needed, it's possible to keep the private key just at the frontend node instead of copy it to all the hypervisor. In this fashion the oneadmin user in the hypervisors won't be able to access other hypervisors. This is achieved by modifying the ``/var/lib/one/.ssh/config`` in the front-end and adding the ``ForwardAgent`` option to the hypervisor hosts for forwarding the key:

.. prompt:: bash $ auto

    $cat /var/lib/one/.ssh/config
     Host host1
        User oneadmin
        ForwardAgent yes
     Host host2
        User oneadmin
        ForwardAgent yes

.. note:: Remember that is neccesary to have running the ssh-agent with the corresponding private key imported before OpenNebula is started. You can start ssh-agent by running ``eval "$(ssh-agent -s)"`` and add the private key by running ``ssh-add /var/lib/one/.ssh/id_rsa``.

.. _kvm_net:

Step 5. Networking Configuration
================================

|image3|

A network connection is needed by the OpenNebula Front-end daemons to access the hosts to manage and monitor the Hosts, and to transfer the Image files. It is highly recommended to use a dedicated network for this purpose.

There are various network models (please check the :ref:`Networking <nm>` chapter to find out the networking technologies supported by OpenNebula).

You may want to use the simplest network model that corresponds to the :ref:`bridged <bridged>` drivers. For this driver, you will need to setup a linux bridge and include a physical device to the bridge. Later on, when defining the network in OpenNebula, you will specify the name of this bridge and OpenNebula will know that it should connect the VM to this bridge, thus giving it connectivity with the physical network device connected to the bridge. For example, a typical host with two physical networks, one for public IP addresses (attached to an ``eth0`` NIC for example) and the other for private virtual LANs (NIC ``eth1`` for example) should have two bridges:

.. prompt:: bash $ auto

    $ brctl show
    bridge name bridge id         STP enabled interfaces
    br0        8000.001e682f02ac no          eth0
    br1        8000.001e682f02ad no          eth1

.. note:: Remember that this is only required in the Hosts, not in the Front-end. Also remember that it is not important the exact name of the resources (``br0``, ``br1``, etc...), however it's important that the bridges and NICs have the same name in all the Hosts.

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

Open the Sunstone as documented :ref:`here <verify_frontend_section_sunstone>`. In the left side menu go to Infrastructure -> Hosts. Click on the ``+`` button.

|sunstone_select_create_host|

The fill-in the fqdn of the node in the Hostname field.

|sunstone_create_host_dialog|

Finally, return to the Hosts list, and check that the Host switch to ON status. It should take somewhere between 20s to 1m. Try clicking on the refresh button to check the status more frequently.

|sunstone_list_hosts|

If the host turns to ``err`` state instead of ``on``, check the ``/var/log/one/oned.log``. Chances are it's a problem with the SSH!

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

If the host turns to ``err`` state instead of ``on``, check the ``/var/log/one/oned.log``. Chances are it's a problem with the SSH!

.. _kvm_wild:

Step 8. Import Currently Running VMs (Optional)
===============================================

You can skip this step as importing VMs can be done at any moment, however, if you wish to see your previously deployed VMs in OpenNebula you can use the :ref:`import VM <import_wild_vms>` functionality.

.. _kvm_next:

Step 9. Next steps
================================================================================

You can now jump to the optional :ref:`Verify your Installation <verify_installation>` section in order to get to launch a test VM.

Otherwise, you are ready to :ref:`start using your cloud <operation_guide>` or you could configure more components:

* :ref:`Authenticaton <authentication>`. (Optional) For integrating OpenNebula with LDAP/AD, or securing it further with other authentication technologies.
* :ref:`Sunstone <sunstone>`. OpenNebula GUI should be working and accessible at this stage, but by reading this guide you will learn about specific enhanced configurations for Sunstone.
* :ref:`Open Cloud Host Setup <vmmg>`.
* :ref:`Open Cloud Storage Setup <storage>`.
* :ref:`Open Cloud Networking Setup <nm>`.

.. |image3| image:: /images/network-02.png
.. |sunstone_create_host_dialog| image:: /images/sunstone_create_host_dialog.png
.. |sunstone_list_hosts| image:: /images/sunstone_list_hosts.png
.. |sunstone_select_create_host| image:: /images/sunstone_select_create_host.png