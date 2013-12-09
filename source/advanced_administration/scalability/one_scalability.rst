============================================
Configuring OpenNebula for Large Deployments
============================================

Monitoring
==========

OpenNebula supports two native monitoring systems: ``ssh-pull`` and
``udp-push``. The former one, ``ssh-pull`` is the default monitoring
system for OpenNebula â‡?4.2, however from OpenNebula 4.4 onwards, the
default monitoring system is the ``udp-push`` system. This model is
highly scalable and its limit (in terms of number of VMs monitored per
second) is bounded to the performance of the server running oned and the
database server. Our scalability testing achieves the monitoring of tens
of thousands of VMs in a few minutes.

Read more in the `Monitoring guide </./mon>`__.

Core Tuning
===========

OpenNebula keeps the monitorization history for a defined time in a
database table. These values are then used to draw the plots in
Sunstone.

These monitorization entries can take quite a bit of storage in your
database. The amount of storage used will depend on the size of your
cloud, and the following configuration attributes in oned.conf:

-  **``MONITORING_INTERVAL``** (VMware only): Time in seconds between
each monitorization. Default: 60.
-  **collectd IM\_MAD ``-i`` argument** (KVM & Xen only): Time in
seconds of the monitorization push cycle. Default: 20.
-  **``HOST_MONITORING_EXPIRATION_TIME``**: Time, in seconds, to expire
monitoring information. Default: 12h.
-  **``VM_MONITORING_EXPIRATION_TIME``**: Time, in seconds, to expire
monitoring information. Default: 4h.

If you don't use Sunstone, you may want to disable the monitoring
history, setting both expiration times to 0.

Each monitoring entry will be around 2 KB for each Host, and 4 KB for
each VM. To give you an idea of how much database storage you will need
to prepare, these some examples:

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

API Tuning
==========

For large deployments with lots of xmlprc calls the default values for
the xmlprc server are too conservative. The values you can modify and
its meaning are explained in the `oned.conf
guide </./oned_conf#xml-rpc_server_configuration>`__ and the `xmlrpc-c
library
documentation <http://xmlrpc-c.sourceforge.net/doc/libxmlrpc_server_abyss.html#max_conn>`__.
From our experience these values improve the server behaviour with a
high amount of client calls:

.. code:: code

MAX_CONN = 240
MAX_CONN_BACKLOG = 480

Driver Tuning
=============

OpenNebula drivers have by default 15 threads. This is the maximum
number of actions a driver can perform at the same time, the next
actions will be queued. You can make this value in oned.conf, the driver
parameter is -t.

Database Tuning
===============

For non test installations use MySQL database. sqlite is too slow for
more than a couple hosts and a few VMs.

Sunstone Tuning
===============

Please refer to guide about `Configuring Sunstone for Large
Deployments </./suns_advance>`__.
