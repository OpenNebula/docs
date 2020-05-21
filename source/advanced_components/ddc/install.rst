.. _ddc_install:

=========================
OneProvision Installation
=========================

All functionality is distributed as an optional operating system package ``opennebula-provision``, which must be installed on your **frontend alongside with the server packages**.

.. important::

    The tool requires `Ansible <https://www.ansible.com/>`__ to be installed on the same host(s) as well. There is **no automatic dependency** which would install Ansible automatically; you have to manage the installation of the required Ansible version on your own.

    Supported versions: Ansible 2.5.x, 2.6.x., 2.7.x or 2.8.x  Note that the Ansible packages in CentOS 7+ and Debian 10+ are too new, and Ubuntu 16.04's is too old.

Step 1. Tools
=============

Installation of the tools is as easy as the installation of any operating system package. Choose from the sections below based on your operating system. You also need to have installed the OpenNebula :ref:`front-end packages <frontend_installation>`.

CentOS/RHEL 7
-------------

.. prompt:: bash $ auto

   $ sudo yum install opennebula-provision

Debian/Ubuntu
-------------

.. prompt:: bash $ auto

   $ sudo apt-get install opennebula-provision

Step 2. Ansible
===============

It's necessary to have Ansible installed. You can use a distribution package if there is a suitable version. Otherwise, you can install the required version via ``pip`` the following way:

CentOS/RHEL 7
-------------

.. prompt:: bash $ auto

   $ sudo yum install python-pip

Debian/Ubuntu
-------------

.. prompt:: bash $ auto

   $ sudo apt-get install python-pip

and, then install Ansible:

.. prompt:: bash $ auto

   $ sudo pip install 'ansible>=2.5.0,<2.10.0'

Check that Ansible is installed properly:

.. prompt:: bash $ auto

    ansible 2.9.9
      config file = None
      configured module search path = [u'/var/lib/one/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
      ansible python module location = /usr/lib/python2.7/site-packages/ansible
      executable location = /bin/ansible
      python version = 2.7.5 (default, Apr  2 2020, 13:16:51) [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)]

.. note:: You need to have Jinja2 version 2.10.0 (or higher). If your operating system is shipped with older, do upgrade with the following command:

    .. prompt:: bash $ auto

        $ sudo pip install 'Jinja2>=2.10.0'
