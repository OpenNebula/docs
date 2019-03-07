.. _one_scalability:

=============================================
Large Deployments
=============================================

Monitoring
==========

In KVM environments, OpenNebula supports two native monitoring systems: ``ssh-pull`` and ``udp-push``. The former one, ``ssh-pull`` is the default monitoring system for OpenNebula <= 4.2, however from OpenNebula 4.4 onwards, the default monitoring system is the ``udp-push`` system. This model is highly scalable and its limit (in terms of number of VMs monitored per second) is bounded to the performance of the server running oned and the database server. Read more in the :ref:`Monitoring guide <mon>`.

For vCenter environments, OpenNebula uses the VI API offered by vCenter to monitor the state of the hypervisor and all the Virtual Machines running in all the imported vCenter clusters. The driver is optimized to cache common VM information.

In both environments, our scalability testing achieves the monitoring of tens of thousands of VMs in a few minutes.

Core Tuning
===========

OpenNebula keeps the monitorization history for a defined time in a database table. These values are then used to draw the plots in Sunstone.

These monitorization entries can take quite a bit of storage in your database. The amount of storage used will depend on the size of your cloud, and the following configuration attributes in :ref:`oned.conf <oned_conf>`:

-  ``MONITORING_INTERVAL_HOST``: Time in seconds between each monitorization. Default: 180.
-  collectd IM\_MAD ``-i`` argument (KVM only): Time in seconds of the monitorization push cycle. Default: 60.
-  ``HOST_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Default: 12h.
-  ``VM_MONITORING_EXPIRATION_TIME``: Time, in seconds, to expire monitoring information. Default: 4h.

If you don't use Sunstone, you may want to disable the monitoring history, setting both expiration times to 0.

Each monitoring entry will be around 2 KB for each Host, and 4 KB for each VM. To give you an idea of how much database storage you will need to prepare, here are some examples:

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

For large deployments with lots of xmlprc calls the default values for the xmlprc server are too conservative. The values you can modify and its meaning are explained in :ref:`oned.conf <oned_conf>` and the `xmlrpc-c library documentation <http://xmlrpc-c.sourceforge.net/doc/libxmlrpc_server_abyss.html#max_conn>`__. From our experience these values improve the server behavior with a high amount of client calls:

.. code-block:: none

    MAX_CONN = 240
    MAX_CONN_BACKLOG = 480

The core is able to paginate some pool answers. This makes the memory consumption decrease and in some cases the parsing faster. By default the pagination value is 2000 objects but can be changed using the environment variable ``ONE_POOL_PAGE_SIZE``. It should be bigger that 2. For example, to list VMs with a page size of 5000 we can use:

.. prompt:: text $ auto

    $ ONE_POOL_PAGE_SIZE=5000 onevm list

To disable pagination we can use a non numeric value:

.. prompt:: text $ auto

    $ ONE_POOL_PAGE_SIZE=disabled onevm list

This environment variable can be also used for Sunstone.

Also, one of the main barriers to scale opennebula is the list operation on large pools. Since OpenNebula 5.9, vm pool is listed in a *summarized* form. However we recommend to make use of the search operation to reduce the pool size returned by oned. The search operation is available for the VM pool since version 5.9.

Driver Tuning
=============

OpenNebula drivers have by default 15 threads. This is the maximum number of actions a driver can perform at the same time, the next actions will be queued. You can make this value in :ref:`oned.conf <oned_conf>`, the driver parameter is ``-t``.

Database Tuning
===============

For non test installations use MySQL database. sqlite is too slow for more than a couple hosts and a few VMs.

Sunstone Tuning
===============

Please refer to guide about :ref:`Configuring Sunstone for Large Deployments <suns_advance>`.

Frontend (oned) Scalability
===========================

There are several aspects that can limit the scalability of a cloud from the storage to the network backend. This guide focus on the scale limits of oned, the controller component, for a single OpenNebula zone. The limits recommended here are associated to a given API load, you may consider to reduce or increase the limits based on your actual API requests. Notice that the maximum number of servers (virtualization hosts) that can be managed by a single OpenNebula instance strongly depends on the performance and scalability of the underlying platform infrastructure, mainly the storage subsystem.

The following results have been obtained with synthetic workloads that stresses oned running on a physical server with the following specifications:

+----------------------+---------------------------------------------------------+
| CPU model:           | Intel(R) Atom(TM) CPU C2550 @ 2.40GHz, 4 cores, no HT   |
+----------------------+---------------------------------------------------------+
| RAM:                 | 8GB, DDR3, 1600 MT/s, single channel                    |
+----------------------+---------------------------------------------------------+
| HDD:                 | INTEL SSDSC2BB150G7                                     |
+----------------------+---------------------------------------------------------+
| OS:                  | Ubuntu 18.04                                            |
+----------------------+---------------------------------------------------------+
| OpenNebula:          | Version 5.8                                             |
+----------------------+---------------------------------------------------------+
| Database:            | MariaDB v10.1 with default configurations               |
+----------------------+---------------------------------------------------------+

In a single zone, OpenNebula (oned) can work with the following limits:

+--------------------------+-----------------------------------------------------+
| Number of hosts          | 2500                                                |
+--------------------------+-----------------------------------------------------+
| Number of VMs            | 10000                                               |
+--------------------------+-----------------------------------------------------+
| Average VM template size | 7 KB                                                |
+--------------------------+-----------------------------------------------------+

In these conditions, with a host monitoring interval of 125 seconds (20 monitoring messages/second), the response time in seconds of the oned process for the most common XMLRPC calls are shown below:

+---------------------------------------------------------------------------------------+
|                               Response Time (seconds)                                 |
+-----------------------+---------------------+--------------------+--------------------+
| API Call - ratio      | API Load: 10 req/s  | API Load: 20 req/s | API Load: 30 req/s |
+-----------------------+---------------------+--------------------+--------------------+
| host.info (30%)       | 0.06                | 0.50               | 0.54               |
+-----------------------+---------------------+--------------------+--------------------+
| Hostpool.info (10%)   | 0.14                | 0.41               | 0.43               |
+-----------------------+---------------------+--------------------+--------------------+
| vm.info (30%)         | 0.07                | 0.57               | 0.51               |
+-----------------------+---------------------+--------------------+--------------------+
| vmpool.info (30%)     | 1.23                | 2.13               | 4.18               |
+-----------------------+---------------------+--------------------+--------------------+

Host Scalability - Monitoring
=============================

The number of VMs (or containers) a node can run is limited by the monitoring probes. In this section we have evaluated the performance of the monitoring probes for the KVM and LXD drivers. The host characteristics are the following:

+---------------+--------------------------------------------------------+
| CPU model:    | Intel(R) Atom(TM) CPU C2550 @ 2.40GHz, 4 cores, no HT  |
+---------------+--------------------------------------------------------+
| RAM:          | 8GB, DDR3, 1600 MT/s, single channel                   |
+---------------+--------------------------------------------------------+
| HDD:          | INTEL SSDSC2BB150G7                                    |
+---------------+--------------------------------------------------------+
| OS:           | Ubuntu 18.04                                           |
+---------------+--------------------------------------------------------+
| Hypervisor:   | Libvirt (4.0), Qemu (2.11), lxd (3.03)                 |
+---------------+--------------------------------------------------------+

Containers and VMs settings used for monitoring tests:

+-------------+-------------------+-------+----------------------+--------------+
| Hypervisor  | OS                | RAM   | Monitor time per VM  | Max. VM/host |
+-------------+-------------------+-------+----------------------+--------------+
| KVM         | None (empty disk) | 32MB  | 0.42                 | 250          |
+-------------+-------------------+-------+----------------------+--------------+
| LXD         | Alpine            | 32MB  | 0.1                  | 250          |
+-------------+-------------------+-------+----------------------+--------------+

Note that there may be other factors that may limit the number of VMs / containers running in a single host.



















