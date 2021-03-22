.. _federationconfig:

================================================================================
Federation Configuration
================================================================================

This section will explain how to configure two (or more) OpenNebula zones to work as federation *master* and *slave*. The process described here can be applied to new installations or existing OpenNebula instances.

OpenNebula *master* zone server replicates database changes on *slaves* using a federated log. The log contains the SQL commands which should be applied in all zones.

.. important:: In the following, each configuration step starts with **Master** or **Slave** to indicate the server where the step must be performed.

.. important:: *Master* and *slave* servers need to talk to each other through their XML-RPC API. You may need to update the ``LISTEN_ADDRESS``, and or ``PORT`` in :ref:`/etc/one/oned.conf <oned_conf>` or any firewall rule blocking this communication. Note that by default this traffic is not secured, so if you are using public links you need to secure the communication.

.. important:: The federation can be setup with MySQL or SQLite backends, but you cannot mix them across zones. MySQL is recommended for production deployments.

Step 1. Configure the OpenNebula Federation Master Zone
================================================================================

Start by picking an OpenNebula to act as master of the federation. The *master* OpenNebula will be responsible for updating shared information across zones and replicating the updates to the *slaves*. You may start with an existing installation or with a new one (see the :ref:`installation guide <ignc>`).

.. note:: When installing a new *master* from scratch be sure to start it at least once to properly bootstrap the database.

- **Master**: Edit the *master* zone endpoint. This can be done via Sunstone, or with the onezone command. Write down this endpoint to use it later when configuring the *slaves*.

.. prompt:: bash $ auto

    $ onezone update 0
    ENDPOINT = http://<master-ip>:2633/RPC2

.. note:: In the HA setup, the ``<master-ip>`` should be set to the **floating** IP address, see :ref:`the HA installation guide <oneha>` for more details. In single server zones, just use the IP of the server.

- **Master**: Update ``/etc/one/oned.conf`` to change the mode to **master**.

.. code-block:: bash

    FEDERATION = [
        MODE    = "MASTER",
        ZONE_ID = 0
    ]

- **Master**: Restart the OpenNebula.

You are now ready to add *slave* zones.

Step 2. Adding a New Federation Slave Zone
================================================================================

- **Slave**: Install OpenNebula on the *slave* as usual following the :ref:`installation guide <ignc>`. Start OpenNebula at least once to bootstrap the zone database.

- **Slave**: Stop OpenNebula.

- **Master**: Create a zone for the *slave*, and write down the new Zone ID. This can be done via Sunstone, or with the onezone command.

.. prompt:: bash $ auto

    $ vim /tmp/zone.tmpl
    NAME     = slave-name
    ENDPOINT = http://<slave-zone-ip>:2633/RPC2

    $ onezone create /tmp/zone.tmpl
    ID: 100

    $ onezone list
       ID NAME
        0 OpenNebula
      100 slave-name

.. note:: In HA setups use the **floating** IP address for the ``<slave-zone-ip>``, in single server zones just use the IP of the server.

- **Master**: Make a snapshot of the federated tables with the following command:

.. prompt:: bash $ auto

    $ onedb backup --federated -s /var/lib/one/one.db
    Sqlite database backup of federated tables stored in /var/lib/one/one.db_federated_2017-6-15_8:52:51.bck
    Use 'onedb restore' to restore the DB.

.. note:: This example shows how to make a database snapshot with SQLite. For MySQL just change the ``-s`` option with the corresponding MySQL options: ``-u <username> -p <password> -d <database_name>``. For SQLite, you need to stop OpenNebula before taking the DB snapshot. This is not required for MySQL.

- **Master**: Copy the database snapshot to the *slave*.

- **Master**: Copy **only selected files** from the directory ``/var/lib/one/.one`` to the *slave*. This directory and its content must have **oneadmin as owner**. Replace only these files:

.. prompt:: bash $ auto

    $ ls -1 /var/lib/one/.one
    ec2_auth
    one_auth
    oneflow_auth
    onegate_auth
    sunstone_auth

- **Slave**: Update ``/etc/one/oned.conf`` to change the mode to **slave**, set the *master's* URL and the ``ZONE_ID`` obtained when the zone was created on *master*:

.. code-block:: bash

    FEDERATION = [
        MODE        = "SLAVE",
        ZONE_ID     = 100,
        MASTER_ONED = "http://<master-ip>:2633/RPC2"
    ]

- **Slave**: Restore the database snapshot:

.. prompt:: bash $ auto

    $ onedb restore --federated -s /var/lib/one/one.db /var/lib/one/one.db_federated_2017-6-14_16:0:36.bck
    Sqlite database backup restored in one.db

- **Slave**: Start OpenNebula.

The zone should be now configured and ready to use.

Step 3. Adding HA to a Federation Slave Zone (Optional)
================================================================================

Now you can start adding more servers to the *slave* zone to provide it with HA capabilities. The procedure is the same as the one described for stand-alone zones in :ref:`the HA installation guide <oneha>`. In this case, the replication works in a multi-tier fashion. The *master* replicates a database change to one of the zone servers. Then this server replicates the change across the zone servers.

.. important:: It is important to double check that the federation is working before adding HA servers to the zone, as you will be updating the zone metadata which is a federated information.

Importing Existing OpenNebula Zones
================================================================================

There is no automatic procedure to import existing users and groups into a running federation. However, you can preserve everything else like datastores, VMs, networks...

- **Slave**: Backup details of users, groups, and VDCs you want to recreate in the federated environment.

- **Slave**: Stop OpenNebula. If the zone was running an HA cluster, stop all servers and pick one of them to add the zone to the federation. Put this server in solo mode by setting ``SERVER_ID`` to ``-1`` in ``/etc/one/oned.conf``.

- **Master, Slave**: Follow the procedure described in Step 2 to add a new zone.

- **Slave**: Recreate any user, group or VDC you need to preserve in the federated environment.

The Zone is now ready to use. If you want to add more HA servers, follow the standard procedure.

Updating a Federation
================================================================================

OpenNebula database has two different version numbers:

- federated (shared) tables version,
- local tables version.

.. important:: To federate OpenNebula zones, they must run the same version of the federated tables (which are pretty stable).

Upgrades to a version that does not increase the federated version can be done asynchronously in each zone. However, an update in the shared table version requires a coordinated update of all zones.

Administration Account Configuration
================================================================================

A Federation will have a unique oneadmin account. This is required to perform API calls across zones. It is recommended to not use this account directly in a production environment, and create an account in the 'oneadmin' group for each Zone administrator.

When additional access restrictions are needed, the Federation Administrator can create a special administrative group with total permissions for one zone only.
