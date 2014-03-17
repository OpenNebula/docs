.. _migrating_46beta:

.. warning:: This guide is under development. The material on this page needs to be reviewed for completeness and accuracy.

==============================
Upgrade from Previous Versions
==============================

A detailed :ref:`upgrade process <upgrade>` can be found in the documentation. For a complete set of changes to migrate from a 4.4 installation please refer to the :ref:`Compatibility Guide <compatibility>`.

.. warning:: With the new :ref:`multi-system DS <system_ds>` functionality, it is now required that the system DS is also part of the cluster. If you are using System DS 0 for Hosts inside a Cluster, any VM saved (stop, suspend, undeploy) **will not be able to be resumed after the upgrade process**.

.. warning:: After the OpenNebula upgrade make sure you run ``onehost sync`` to update the monitoring probes.

