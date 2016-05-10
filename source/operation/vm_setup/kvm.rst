.. _kvm_contextualization:

=====================
KVM Contextualization
=====================

Step 1. Start a VM with the OS you want to Customize
====================================================

Supported contextualization packages are available for the following OSs:

* **CentOS/RHEL** >= 6
* **Debian** >= 6
* **Ubuntu** >= 11.10
* **Windows** >= 7
* **Windows Server** >= 2008

Step 2. Download Contextualization Packages to the VM
=====================================================

CentOS/RHEL
-----------

.. prompt:: bash # auto

    # wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context-ec2_4.14.4.rpm

Debian/Ubuntu
-------------

.. prompt:: bash # auto

    # wget https://github.com/OpenNebula/addon-context-linux/releases/download/v4.14.4/one-context_4.14.4.deb

Step 2. Install Contextualization Packages and Dependencies
===========================================================

CentOS/RHEL 6
-------------

.. prompt:: bash # auto

    # rpm -Uvh one-context*rpm
    # yum install -y epel-release
    # yum install -i dracut-modules-growroot
    # dracut -f

CentOS/RHEL 7
-------------

.. prompt:: bash # auto

    # rpm -Uvh one-context*rpm
    # yum install -y epel-release
    # yum install -y cloud-utils-growpart


