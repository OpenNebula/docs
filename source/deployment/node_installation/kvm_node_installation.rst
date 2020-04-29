.. _kvm_node:

=====================
KVM Node Installation
=====================

This page shows you how to install OpenNebula from the binary packages.

Using the packages provided on our site is the recommended method, to ensure the installation of the latest version and to avoid possible package divergences in different distributions. There are two alternatives here: you can add **our package repositories** to your system, or visit the `software menu <http://opennebula.org/software>`__ to **download the latest package** for your Linux distribution.

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

Newer QEMU/KVM (only CentOS/RHEL 7)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
    $ sudo apt-get install opennebula-node
    $ sudo service libvirtd restart # debian
    $ sudo service libvirt-bin restart # ubuntu

For further configuration check the specific guide: :ref:`KVM <kvmg>`.

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

The OpenNebula Front-end connects to the hypervisor Hosts using SSH. You must distribute the public key of the ``oneadmin`` user from all machines to the file ``/var/lib/one/.ssh/authorized_keys`` in all the machines. There are many methods to achieve the distribution of the SSH keys. Ultimately the administrator should choose a method; the recommendation is to use a configuration management system. In this guide we are going to manually scp the SSH keys.

.. important:: There is now a better alternative to just distributing the oneadmin's SSH private key accross all nodes - by using the **OpenNebula's SSH agent**: ``opennebula-ssh-agent.service``

   This SSH agent service is supported since the OpenNebula version 5.12 and it is enabled by **default**. The utilization of the SSH agent service is not mandatory and you can simply disable it via systemd facility if there is such need (e.g.: ``systemctl disable opennebula-ssh-agent.service``). **Although** in such a case when SSH agent service is disabled - you must fallback to the distribution of the oneadmin's SSH private key yet again as it was necessary until now.

When the package was installed in the Front-end, a SSH key pair was generated and the ``authorized_keys`` populated. We will sync the ``authorized_keys`` (and if SSH agent is disabled then also ``id_rsa`` and ``id_rsa.pub``) from the Front-end to the nodes. Additionally we need to create a ``known_hosts`` file and sync it to the nodes as well.

With enabled SSH agent service (default)
----------------------------------------

Firstly make sure that you are logged in on the Front-end as ``oneadmin`` - for example like this:

.. prompt:: bash $ auto

    $ su - oneadmin

To create the ``known_hosts`` file, we have to execute this command as user ``oneadmin`` on the Front-end (step above) with **ALL** the node names **including** the Front-end as parameters:

.. prompt:: bash $ auto

    $ ALL_HOSTS="frontend node1 node2 node3" # adjust to your situation
    $ ssh-keyscan ${ALL_HOSTS} >> /var/lib/one/.ssh/known_hosts

Now we need to copy these files from the Front-end to the rest of the nodes.

.. note:: The easiest way is to setup a temporary password for the ``oneadmin`` user on all the hosts.

With the SSH agent we only need to distribute the public portion of the oneadmin's SSH keys (``authorized_keys`` or just ``id_rsa.pub``) and also the ``known_hosts`` file. If your installation/environment does not have some special requirements then only the ``oneadmin`` user is needed to connect to the other nodes (as ``oneadmin``). So we can just distribute the ``id_rsa.pub`` instead of the whole ``authorized_keys``.

Let's enable the passwordless login for the ``oneadmin`` user - here you will need to type the password for each node:

.. prompt:: bash $ auto

    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub oneadmin@node1 # adjust the node name
    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub oneadmin@node2 # adjust the node name
    $ ssh-copy-id -i /var/lib/one/.ssh/id_rsa.pub oneadmin@node3 # adjust the node name

Now the authorization is in place and we can automate the rest (no more passwords):

.. prompt:: bash $ auto

    $ NODES="node1 node2 node3" # adjust to your situation
    $ for node in ${NODES} ; do scp -p /var/lib/one/.ssh/known_hosts ${node}:/var/lib/one/.ssh/ ; done

If you wish to enable the passwordless login for ``oneadmin`` on each node in exactly the same manner as it is on the Front-end then you can copy the ``authorized_keys`` now:

.. prompt:: bash $ auto

    $ NODES="node1 node2 node3" # adjust to your situation
    $ for node in ${NODES} ; do scp -p /var/lib/one/.ssh/authorized_keys ${node}:/var/lib/one/.ssh/ ; done

You should try and verify that none of these connections (as user ``oneadmin``) requires a password:

   * from the Front-end to itself
   * from the Front-end to the nodes
   * from the nodes to the Front-end

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

.. note:: If you wish to add your oneadmin's SSH key from different non-standard location or interactively because it is encrypted then this is the way to do it:

   .. prompt:: bash $ auto

      $ SSH_AUTH_SOCK=/var/run/one/ssh-agent.sock ssh-add .ssh/id_rsa

   And this is how you can verify it that it was added:

   .. prompt:: bash $ auto

      $ SSH_AUTH_SOCK=/var/run/one/ssh-agent.sock ssh-add -l


With disabled SSH agent service (optional - not recommended)
------------------------------------------------------------

.. warning:: If SSH agent service is **disabled** then you must copy both the private and public part of the oneadmin's SSH key pair.

   Simply copy the whole directory ``/var/lib/one/.ssh`` to all the nodes.:

   .. prompt:: bash $ auto

       $ scp -rp /var/lib/one/.ssh node1:/var/lib/one/ # adjust the node name
       $ scp -rp /var/lib/one/.ssh node2:/var/lib/one/ # adjust the node name
       $ scp -rp /var/lib/one/.ssh node3:/var/lib/one/ # adjust the node name

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
