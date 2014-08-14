.. _qs_centos_xen:

==========================================
Quickstart: OpenNebula on CentOS 6 and Xen
==========================================

The purpose of this guide is to provide users with step by step guide to install OpenNebula using CentOS 6 as the operating system and Xen as the hypervisor.

After following this guide, users will have a working OpenNebula with graphical interface (Sunstone), at least one hypervisor (host) and a running virtual machines. This is useful at the time of setting up pilot clouds, to quickly test new features and as base deployment to build a large infrastructure.

Throughout the installation there are two separate roles: **Frontend** and **Nodes**. The Frontend server will execute the OpenNebula services, and the Nodes will be used to execute virtual machines. Please not that **it is possible** to follow this guide with just one host combining both the Frontend and Nodes roles in a single server. However it is recommended execute virtual machines in hosts with virtualization extensions. To test if your host supports virtualization extensions, please run:

.. code::

    grep -E 'svm|vmx' /proc/cpuinfo

If you don't get any output you probably don't have virtualization extensions supported/enabled in your server.

Package Layout
==============

-  opennebula-server: OpenNebula Daemons
-  opennebula: OpenNebula CLI commands
-  opennebula-sunstone: OpenNebula's web GUI
-  opennebula-java: OpenNebula Java API
-  opennebula-node-kvm: Installs dependencies required by OpenNebula in the nodes
-  opennebula-gate: Send information from Virtual Machines to OpenNebula
-  opennebula-flow: Manage OpenNebula Services
-  opennebula-context: Package for OpenNebula Guests

Additionally ``opennebula-common`` and ``opennebula-ruby`` exist but they're intended to be used as dependencies.

.. warning:: In order to avoid problems, we recommend to disable SELinux in all the nodes, **Frontend** and **Nodes**:

    .. code::

        # vi /etc/sysconfig/selinux
        ...
        SELINUX=disabled
        ...

        # setenforce 0
        # getenforce
        Permissive

Step 1. Installation in the Frontend
====================================

.. note:: Commands prefixed by ``#`` are meant to be run as ``root``. Commands prefixed by ``$`` must be run as ``oneadmin``.

1.1. Install the repo
---------------------

Enable the `EPEL <https://fedoraproject.org/wiki/EPEL>`__ repo:

.. code::

    # yum install http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

Add the OpenNebula repository:

.. code::

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=opennebula
    baseurl=http://downloads.opennebula.org/repo/4.8/CentOS/6/x86_64/
    enabled=1
    gpgcheck=0
    EOT

1.2. Install the required packages
----------------------------------

A complete install of OpenNebula will have at least both ``opennebula-server`` and ``opennebula-sunstone`` package:

.. code::

    # yum install opennebula-server opennebula-sunstone

Now run ``install_gems`` to install all the gem dependencies. Choose the *CentOS/RedHat* if prompted:

.. code::

    # /usr/share/one/install_gems
    lsb_release command not found. If you are using a RedHat based
    distribution install redhat-lsb

    Select your distribution or press enter to continue without
    installing dependencies.

    0. Ubuntu/Debian
    1. CentOS/RedHat
    2. SUSE

1.3. Configure and Start the services
-------------------------------------

There are two main processes that must be started, the main OpenNebula daemon: ``oned``, and the graphical user interface: ``sunstone``.

``Sunstone`` listens only in the loopback interface by default for security reasons. To change it edit ``/etc/one/sunstone-server.conf`` and change ``:host: 127.0.0.1`` to ``:host: 0.0.0.0``.

Now we can start the services:

.. code::

    # service opennebula start
    # service opennebula-sunstone start

1.4. Configure NFS
------------------

.. note:: Skip this section if you are using a single server for both the frontend and worker node roles.

Export ``/var/lib/one/`` from the frontend to the worker nodes. To do so add the following to the ``/etc/exports`` file in the frontend:

.. code::

    /var/lib/one/ *(rw,sync,no_subtree_check,root_squash)

Refresh the NFS exports by doing:

.. code::

    # service rpcbind restart
    # service nfs restart

1.5. Configure SSH Public Key
-----------------------------

OpenNebula will need to SSH passwordlessly from any node (including the frontend) to any other node.

Add the following snippet to ``~/.ssh/config`` as ``oneadmin`` so it doesn't prompt to add the keys to the ``known_hosts`` file:

.. code::

    # su - oneadmin
    $ cat << EOT > ~/.ssh/config
    Host *
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
    EOT
    $ chmod 600 ~/.ssh/config

Step 2. Installation in the Nodes
=================================

.. warning:: The process to install Xen might change in the future. Please refer to the CentOS documenation on `Xen4 CentOS6 QuickStart <http://wiki.centos.org/HowTos/Xen/Xen4QuickStart>`__ if any of the following steps do not work.

2.1. Install the repo
---------------------

Add the CentOS Xen repo:

.. code::

    # yum install centos-release-xen

Add the OpenNebula repository:

.. code::

    # cat << EOT > /etc/yum.repos.d/opennebula.repo
    [opennebula]
    name=opennebula
    baseurl=http://downloads.opennebula.org/repo/4.8/CentOS/6/x86_64/
    enabled=1
    gpgcheck=0
    EOT

2.2. Install the required packages
----------------------------------

.. code::

    # yum install opennebula-common xen nfs-utils ruby

Enable the Xen kernel by doing:

.. code::

    # /usr/bin/grub-bootxen.sh

Disable ``xend`` since it is a deprecated interface:

.. code::

    # chkconfig xend off

Now you must **reboot** the system in order to start with a Xen kernel.

2.3. Configure the Network
--------------------------

.. warning:: Backup all the files that are modified in this section before making changes to them.

You will need to have your main interface, typically ``eth0``, connected to a bridge. The name of the bridge should be the same in all nodes.

To do so, substitute ``/etc/sysconfig/network-scripts/ifcfg-eth0`` with:

.. code::

    DEVICE=eth0
    BOOTPROTO=none
    NM_CONTROLLED=no
    ONBOOT=yes
    TYPE=Ethernet
    BRIDGE=br0

And add a new ``/etc/sysconfig/network-scripts/ifcfg-br0`` file.

If you were using DHCP for your ``eth0`` interface, use this template:

.. code::

    DEVICE=br0
    TYPE=Bridge
    ONBOOT=yes
    BOOTPROTO=dhcp
    NM_CONTROLLED=no

If you were using a static IP address use this other template:

.. code::

    DEVICE=br0
    TYPE=Bridge
    IPADDR=<YOUR_IPADDRESS>
    NETMASK=<YOUR_NETMASK>
    ONBOOT=yes
    BOOTPROTO=static
    NM_CONTROLLED=no

After these changes, restart the network:

.. code::

    # service network restart

2.4. Configure NFS
------------------

.. note:: Skip this section if you are using a single server for both the frontend and worker node roles.

Mount the datastores export. Add the following to your ``/etc/fstab``:

.. code::

    192.168.1.1:/var/lib/one/  /var/lib/one/  nfs   soft,intr,rsize=8192,wsize=8192,noauto

.. note:: Replace ``192.168.1.1`` with the IP of the frontend.

Mount the NFS share:

.. code::

    # mount /var/lib/one/

If the above command fails or hangs, it could be a firewall issue.

Step 3. Basic Usage
===================

.. note:: All the operations in this section can be done using Sunstone instead of the command line. Point your browser to: ``http://frontend:9869``.

The default password for the ``oneadmin`` user can be found in ``~/.one/one_auth`` which is randomly generated on every installation.

|image1|

To interact with OpenNebula, you have to do it from the ``oneadmin`` account in the frontend. We will assume all the following commands are performed from that account. To login as ``oneadmin`` execute ``su - oneadmin``.

3.1. Adding a Host
------------------

To start running VMs, you should first register a worker node for OpenNebula.

Issue this command for each one of your nodes. Replace ``localhost`` with your node's hostname.

.. code::

    $ onehost create localhost -i xen -v xen -n dummy

Run ``onehost list`` until it's set to on. If it fails you probably have something wrong in your ssh configuration. Take a look at ``/var/log/one/oned.log``.

3.2. Adding virtual resources
-----------------------------

Once it's working you need to create a network, an image and a virtual machine template.

To create networks, we need to create first a network template file ``mynetwork.one`` that contains:

.. code::

    NAME = "private"

    BRIDGE = br0

    AR = [
        TYPE = IP4,
        IP = 192.168.0.100,
        SIZE = 3
    ]

.. note:: Replace the address range with free IPs in your host's network. You can add more than one address range.

Now we can move ahead and create the resources in OpenNebula:

.. code::

    $ onevnet create mynetwork.one

    $ oneimage create --name "CentOS-6.5_x86_64" \
        --path "http://appliances.c12g.com/CentOS-6.5/centos6.5.qcow2.gz" \
        --driver qcow2 \
        --datastore default

    $ onetemplate create --name "CentOS-6.5" --cpu 1 --vcpu 1 --memory 512 \
        --arch x86_64 --disk "CentOS-6.5_x86_64" --nic "private" --vnc \
        --ssh

You will need to wait until the image is ready to be used. Monitor its state by running ``oneimage list``.

We must specify the desired bootloader to the template we just created. To do so execute the following command:

.. code::

    $ EDITOR=vi onetemplate update CentOS-6.5

Add a new line to the OS section of the template that specifies the bootloader:

.. code::

    OS=[
      BOOTLOADER = "pygrub",
      ARCH="x86_64" ]

In order to dynamically add ssh keys to Virtual Machines we must add our ssh key to the user template, by editing the user template:

.. code::

    $ EDITOR=vi oneuser update oneadmin

Add a new line like the following to the template:

.. code::

    SSH_PUBLIC_KEY="ssh-dss AAAAB3NzaC1kc3MAAACBANBWTQmm4Gt..."

Substitute the value above with the output of ``cat ~/.ssh/id_dsa.pub``.

3.3. Running a Virtual Machine
------------------------------

To run a Virtual Machine, you will need to instantiate a template:

.. code::

    $ onetemplate instantiate "CentOS-6.5" --name "My Scratch VM"

Execute ``onevm list`` and watch the virtual machine going from PENDING to PROLOG to RUNNING. If the vm fails, check the reason in the log: ``/var/log/one/<VM_ID>/vm.log``.

Further information
===================

-  :ref:`Planning the Installation <plan>`
-  :ref:`Installing the Software <ignc>`
-  `FAQs. Good for troubleshooting <http://wiki.opennebula.org/faq>`__
-  :ref:`Main Documentation <entry_point>`

.. |image1| image:: /images/admin_view.png
