.. _one_scalability:

=============================================
Large Deployments
=============================================

Monitoring
==========

In KVM environments, OpenNebula supports two native monitoring systems: ``ssh-pull`` and ``udp-push``. The former one, ``ssh-pull`` is the default monitoring system for OpenNebula <= 4.2, however from OpenNebula 4.4 onwards, the default monitoring system is the ``udp-push`` system. This model is highly scalable and its limit (in terms of number of VMs monitored per second) is bounded to the performance of the server running oned and the database server.

For vCenter environments, OpenNebula uses the VI API offered by vCenter to monitor the state of the hypervisor and all the Virtual Machines running in all the imported vCenter clusters. The driver is optimized to cache common VM information.

In both environments, our scalability testing achieves the monitoring of tens of thousands of VMs in a few minutes.

Read more in the :ref:`Monitoring guide <mon>`.

Core Tuning
===========

OpenNebula keeps the monitorization history for a defined time in a database table. These values are then used to draw the plots in Sunstone.

These monitorization entries can take quite a bit of storage in your database. The amount of storage used will depend on the size of your cloud, and the following configuration attributes in oned.conf:

-  ``MONITORING_INTERVAL``: Time in seconds between each monitorization. Default: 60.
-  collectd IM\_MAD ``-i`` argument (KVM only): Time in seconds of the monitorization push cycle. Default: 20.
-  ``HOST_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Default: 12h.
-  ``VM_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Default: 4h.

If you don't use Sunstone, you may want to disable the monitoring history, setting both expiration times to 0.

Each monitoring entry will be around 2 KB for each Host, and 4 KB for each VM. To give you an idea of how much database storage you will need to prepare, these some examples:

+-----------------------+-------------------+-----------+-----------+
| Monitoring interval   | Host expiration   | # Hosts   | Storage   |
+=======================+===================+===========+===========+
| 20s                   | 12h               | 200       | 850 MB    |
+-----------------------+-------------------+-----------+-----------+
| 20s                   | 24h               | 1000      | 8.2 GB    |
+-----------------------+-------------------+-----------+-----------+

+-----------------------+-----------------+---------+-----------+
| Monitoring interval   | VM expiration   | # VMs   | Storage   |
+=======================+=================+=========+===========+
| 20s                   | 4h              | 2000    | 1.8 GB    |
+-----------------------+-----------------+---------+-----------+
| 20s                   | 24h             | 10000   | 7 GB      |
+-----------------------+-----------------+---------+-----------+

.. _one_scalability_api_tuning:

API Tuning
==========

For large deployments with lots of xmlprc calls the default values for the xmlprc server are too conservative. The values you can modify and its meaning are explained in the :ref:`oned.conf guide <oned_conf>` and the `xmlrpc-c library documentation <http://xmlrpc-c.sourceforge.net/doc/libxmlrpc_server_abyss.html#max_conn>`__. From our experience these values improve the server behaviour with a high amount of client calls:

.. code::

    MAX_CONN = 240
    MAX_CONN_BACKLOG = 480

OpenNebula Cloud API (OCA) is able to use the library `Ox <https://rubygems.org/gems/ox>`__ for XML parsing. This library is makes the parsing of pools much faster. It is used by both the CLI and Sunstone so both will benefit from it.

The core is able to paginate some pool answers. This makes the memory consumption decrease and in some cases the parsing faster. By default the pagination value is 2000 objects but can be changed using the environment variable ``ONE_POOL_PAGE_SIZE``. It should be bigger that 2. For example, to list VMs with a page size of 5000 we can use:

.. code::

    $ ONE_POOL_PAGE_SIZE=5000 onevm list

To disable pagination we can use a non numeric value:

.. code::

    $ ONE_POOL_PAGE_SIZE=disabled onevm list

This environment variable can be also used for Sunstone.

Driver Tuning
=============

OpenNebula drivers have by default 15 threads. This is the maximum number of actions a driver can perform at the same time, the next actions will be queued. You can make this value in oned.conf, the driver parameter is -t.

Database Tuning
===============

For non test installations use MySQL database. sqlite is too slow for more than a couple hosts and a few VMs.

Sunstone Tuning
===============

Please refer to guide about :ref:`Configuring Sunstone for Large Deployments <suns_advance>`.
