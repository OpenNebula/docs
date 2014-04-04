.. _cloud-init:

===========
Cloud-init
===========

Since version 0.7.3 of cloud-init packages the OpenNebula context CD is supported. It is able to get and configure networking, hostname, ssh key for root and cloud-init user data. Here are the options in a table:

+----------------------------+-----------------------------------------------------------------------------+
| Option                     | Description                                                                 |
+============================+=============================================================================+
| standard network options   | OpenNebula network parameters in the context added by ``NETWORK=yes``       |
+----------------------------+-----------------------------------------------------------------------------+
| HOSTNAME                   | VM hostname                                                                 |
+----------------------------+-----------------------------------------------------------------------------+
| SSH\_PUBLIC\_KEY           | ssh public key added to root's authorized keys                              |
+----------------------------+-----------------------------------------------------------------------------+
| USER\_DATA                 | Specific user data for cloud-init                                           |
+----------------------------+-----------------------------------------------------------------------------+
| DSMODE                     | Can be set to local, net or disabled to change cloud-init datasource mode   |
+----------------------------+-----------------------------------------------------------------------------+

You have more information on how to use it at the `cloud-init documentation page <http://cloudinit.readthedocs.org/en/latest/topics/datasources.html#opennebula>`__.

There are plenty of examples on what can go in the USER\_DATA string at the `cloud-init examples page <http://cloudinit.readthedocs.org/en/latest/topics/examples.html>`__.

.. warning:: The current version of cloud-init configures the network before running cloud-init configuration. This makes the network configuration not reliable. Until a new version that fixes this is released you can add OpenNebula context packages or this user data to reboot the machine so the network is properly configured.

.. code::

    CONTEXT=[
      USER_DATA="#cloud-config
    power_state:
     mode: reboot
    " ]


Platform Specific Notes
=======================

CentOS
------

Works correctly for ``cloud-init >= 0.7.4``.

Ubuntu/Debian
-------------

To make it configure the network correctly it needs to be down so the network configuration
part makes its work:

.. code::

    CONTEXT=[
      NETWORK="YES",
      SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]",
      USER_DATA="#cloud-config
    bootcmd:
      - ifdown -a
    runcmd:
      - curl http://10.0.1.1:8999/I_am_alive
    write_files:
    -   encoding: b64
        content: RG9lcyBpdCB3b3JrPwo=
        owner: root:root
        path: /etc/test_file
        permissions: '0644'
    packages:
      - ruby2.0" ]
